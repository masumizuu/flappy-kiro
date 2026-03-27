/// AudioManager.swift
/// Flappy Kiro
///
/// Manages all game audio using a two-level fallback chain:
///
///   Level 1 — Synthesis:  AVAudioEngine generates tones programmatically.
///   Level 2 — WAV files:  AVAudioPlayer loads bundled .wav assets.
///   Level 3 — Silent:     Both failed; game continues without audio.
///
/// Why programmatic synthesis?
///   It avoids shipping large audio files and lets us tune the sound to match
///   the cutesy aesthetic. A short ascending chirp for jump, a descending
///   wah-wah for game over.
///
/// Security notes:
///   SECURITY-15: All AVAudioEngine calls are wrapped in do/catch.
///   SECURITY-03: Errors are logged to stderr only — never shown to the user.

import AVFoundation

final class AudioManager {

    // MARK: - Audio Mode

    /// Tracks which audio backend is currently active.
    private enum AudioMode {
        case synthesis    // AVAudioEngine programmatic tones
        case wavFallback  // AVAudioPlayer + bundled .wav files
        case silent       // both failed; no audio
    }

    // MARK: - State

    private var mode: AudioMode = .silent

    // Synthesis backend
    private var engine: AVAudioEngine?
    private var playerNode: AVAudioPlayerNode?

    // WAV fallback backend
    private var jumpPlayer:     AVAudioPlayer?
    private var gameOverPlayer: AVAudioPlayer?

    // MARK: - Setup

    /// Configures the audio backend. Call once when the scene loads.
    func setup() {
        if attemptSynthesisSetup() {
            mode = .synthesis
            Logger.debug("AudioManager: using AVAudioEngine synthesis")
        } else if attemptWavSetup() {
            mode = .wavFallback
            Logger.debug("AudioManager: using .wav fallback")
        } else {
            mode = .silent
            Logger.error("AudioManager: all audio backends failed — running silent")
        }
    }

    /// Stops the audio engine and releases resources. Call when the scene deallocates.
    func teardown() {
        engine?.stop()
        engine = nil
        playerNode = nil
    }

    // MARK: - Playback

    /// Plays the jump sound (short ascending chirp).
    func playJump() {
        switch mode {
        case .synthesis:   playSynthesisedTone(startHz: 520, endHz: 880, duration: 0.08)
        case .wavFallback: jumpPlayer?.play()
        case .silent:      break
        }
    }

    /// Plays the game-over sound (descending wah).
    func playGameOver() {
        switch mode {
        case .synthesis:   playSynthesisedTone(startHz: 440, endHz: 110, duration: 0.45)
        case .wavFallback: gameOverPlayer?.play()
        case .silent:      break
        }
    }

    // MARK: - Synthesis Setup

    private func attemptSynthesisSetup() -> Bool {
        do {
            let eng  = AVAudioEngine()
            let node = AVAudioPlayerNode()
            eng.attach(node)
            eng.connect(node, to: eng.mainMixerNode, format: nil)
            try eng.start()
            engine     = eng
            playerNode = node
            return true
        } catch {
            Logger.error("AudioManager synthesis setup failed: \(error.localizedDescription)")
            return false
        }
    }

    /// Generates a sine-wave tone that sweeps from `startHz` to `endHz` over `duration` seconds,
    /// with a simple linear ADSR envelope (attack + decay baked into amplitude ramp).
    private func playSynthesisedTone(startHz: Double, endHz: Double, duration: Double) {
        guard let node = playerNode, let eng = engine, eng.isRunning else { return }

        let sampleRate: Double = 44100
        let frameCount = AVAudioFrameCount(sampleRate * duration)
        guard let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1),
              let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount)
        else { return }

        buffer.frameLength = frameCount
        guard let channelData = buffer.floatChannelData?[0] else { return }

        // Build the waveform sample by sample.
        for i in 0..<Int(frameCount) {
            let t          = Double(i) / sampleRate
            let progress   = t / duration
            // Linearly interpolate frequency from start to end.
            let hz         = startHz + (endHz - startHz) * progress
            // Simple envelope: fade in over first 10%, fade out over last 30%.
            let envelope: Double
            if progress < 0.1 {
                envelope = progress / 0.1
            } else if progress > 0.7 {
                envelope = (1.0 - progress) / 0.3
            } else {
                envelope = 1.0
            }
            let phase      = 2.0 * Double.pi * hz * t
            channelData[i] = Float(sin(phase) * envelope * 0.4)
        }

        node.scheduleBuffer(buffer, completionHandler: nil)
        if !node.isPlaying { node.play() }
    }

    // MARK: - WAV Fallback Setup

    private func attemptWavSetup() -> Bool {
        var success = true
        success = loadWav(named: "jump",      into: &jumpPlayer)     && success
        success = loadWav(named: "game_over", into: &gameOverPlayer) && success
        return success
    }

    private func loadWav(named name: String, into player: inout AVAudioPlayer?) -> Bool {
        guard let url = Bundle.main.url(forResource: name, withExtension: "wav") else {
            Logger.error("AudioManager: '\(name).wav' not found in bundle")
            return false
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            return true
        } catch {
            Logger.error("AudioManager: failed to load '\(name).wav': \(error.localizedDescription)")
            return false
        }
    }
}
