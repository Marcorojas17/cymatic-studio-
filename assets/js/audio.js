/**
 * ============================================================
 * CYMATIC STUDIO v24 · HI-FI AUDIO ENGINE
 * Síntesis de sonidos interactivos con Web Audio API.
 * ============================================================
 */

(function() {
    'use strict';

    let audioCtx = null;
    let isInitialized = false;

    /**
     * Inicializa el contexto de audio (se llama en el primer clic del usuario).
     * @returns {AudioContext|null}
     */
    function initAudio() {
        if (!audioCtx) {
            try {
                audioCtx = new(window.AudioContext || window.webkitAudioContext)();
                if (audioCtx.state === 'suspended') {
                    audioCtx.resume();
                }
                isInitialized = true;
                console.log('🎵 Audio engine inicializado.');
            } catch (e) {
                console.warn('Web Audio API no soportada:', e);
                return null;
            }
        }
        return audioCtx;
    }

    /**
     * Reproduce un sonido sintético.
     * @param {string} type - 'click' | 'hover' | 'open' | 'quantum'
     */
    function playSound(type) {
        try {
            const ctx = initAudio();
            if (!ctx) return;

            const now = ctx.currentTime;
            const osc = ctx.createOscillator();
            const gain = ctx.createGain();
            const filter = ctx.createBiquadFilter();
            filter.type = 'lowpass';
            filter.frequency.setValueAtTime(4000, now);

            let freq = 800,
                duration = 0.08,
                volume = 0.12;
            let waveform = 'sine';

            switch (type) {
                case 'hover':
                    freq = 1200;
                    duration = 0.06;
                    volume = 0.06;
                    break;
                case 'open':
                    freq = 587.33; // Re5
                    duration = 0.2;
                    volume = 0.15;
                    waveform = 'sine';
                    break;
                case 'quantum':
                    freq = 440;
                    duration = 0.4;
                    volume = 0.18;
                    waveform = 'triangle';
                    break;
                case 'click':
                default:
                    freq = 800;
                    duration = 0.08;
                    volume = 0.12;
                    waveform = 'sine';
                    break;
            }

            osc.type = waveform;
            osc.frequency.setValueAtTime(freq, now);

            // Glide de frecuencia para calidez
            if (type === 'quantum') {
                osc.frequency.exponentialRampToValueAtTime(880, now + 0.15);
            } else if (type === 'open') {
                osc.frequency.exponentialRampToValueAtTime(freq * 1.1, now + 0.1);
            }

            gain.gain.setValueAtTime(volume, now);
            gain.gain.exponentialRampToValueAtTime(0.001, now + duration);

            osc.connect(gain);
            gain.connect(filter);
            filter.connect(ctx.destination);

            osc.start(now);
            osc.stop(now + duration);

        } catch (e) {
            // Silencio seguro si falla el audio
        }
    }

    /**
     * Reproduce un sonido con un tono específico.
     * @param {number} frequency - Frecuencia en Hz.
     * @param {number} duration - Duración en segundos.
     * @param {number} volume - Volumen (0-1).
     */
    function playTone(frequency, duration = 0.2, volume = 0.1) {
        try {
            const ctx = initAudio();
            if (!ctx) return;

            const now = ctx.currentTime;
            const osc = ctx.createOscillator();
            const gain = ctx.createGain();

            osc.type = 'sine';
            osc.frequency.setValueAtTime(frequency, now);

            gain.gain.setValueAtTime(volume, now);
            gain.gain.exponentialRampToValueAtTime(0.001, now + duration);

            osc.connect(gain);
            gain.connect(ctx.destination);

            osc.start(now);
            osc.stop(now + duration);
        } catch (e) {
            // Silencio
        }
    }

    // ============================================================
    // EXPOSICIÓN GLOBAL
    // ============================================================

    window.playSound = playSound;
    window.playTone = playTone;
    window.initAudio = initAudio;
    window.audioCtx = null; // Se asigna en el primer clic

    // Pre-cargar audio context en el primer clic del usuario
    document.addEventListener('click', function initAudioOnFirstClick() {
        initAudio();
        document.removeEventListener('click', initAudioOnFirstClick);
    }, { once: true });

    console.log('🎧 Audio Hi‑Fi engine cargado. Escucha sonidos al interactuar.');

})();
