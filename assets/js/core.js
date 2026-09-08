/**
 * ============================================================
 * CYMATIC STUDIO v24 · CORE CONTROLLER
 * Gestión de temas, cursor personalizado y sistema de licencia.
 * ============================================================
 */

(function() {
    'use strict';

    // ============================================================
    // 1. SISTEMA DE TEMAS (oscuro, claro, alto contraste)
    // ============================================================

    window.CymaticTheme = {
        _storageKey: 'cymatic-theme-v24',
        _current: 'dark',

        /**
         * Establece un tema específico.
         * @param {string} theme - 'dark' | 'light' | 'contrast'
         */
        set: function(theme) {
            const valid = ['light', 'dark', 'contrast'];
            if (!valid.includes(theme)) theme = 'dark';

            document.body.classList.remove('theme-light', 'theme-dark', 'high-contrast');
            if (theme === 'contrast') {
                document.body.classList.add('high-contrast');
            } else {
                document.body.classList.add('theme-' + theme);
            }
            localStorage.setItem(this._storageKey, theme);
            this._current = theme;
            window.dispatchEvent(new CustomEvent('themeChange', { detail: { theme } }));
        },

        /**
         * Alterna entre los temas disponibles.
         */
        toggle: function() {
            const order = ['dark', 'light', 'contrast'];
            const idx = order.indexOf(this._current);
            const next = order[(idx + 1) % order.length];
            this.set(next);
        },

        /**
         * Obtiene el tema actual.
         * @returns {string}
         */
        get: function() {
            return this._current;
        },

        /**
         * Inicializa el tema según preferencia guardada o del sistema.
         */
        init: function() {
            const saved = localStorage.getItem(this._storageKey);
            if (saved && ['light', 'dark', 'contrast'].includes(saved)) {
                this.set(saved);
                return;
            }
            const prefersLight = window.matchMedia('(prefers-color-scheme: light)').matches;
            this.set(prefersLight ? 'light' : 'dark');

            // Escuchar cambios en la preferencia del sistema
            window.matchMedia('(prefers-color-scheme: light)').addEventListener('change', (e) => {
                if (!localStorage.getItem(this._storageKey)) {
                    this.set(e.matches ? 'light' : 'dark');
                }
            });
        }
    };

    // ============================================================
    // 2. CURSOR PERSONALIZADO (opcional, para páginas que lo usen)
    // ============================================================

    window.CymaticCursor = {
        _element: null,
        _enabled: false,

        /**
         * Activa el cursor personalizado.
         */
        enable: function() {
            if (this._enabled) return;
            this._enabled = true;

            const cursor = document.createElement('div');
            cursor.className = 'custom-cursor';
            cursor.id = 'q-cursor';
            cursor.setAttribute('aria-hidden', 'true');
            document.body.appendChild(cursor);
            this._element = cursor;

            let mx = window.innerWidth / 2,
                my = window.innerHeight / 2;
            let cx = mx,
                cy = my;
            let frameId = null;

            const update = () => {
                cx += (mx - cx) * 0.15;
                cy += (my - cy) * 0.15;
                cursor.style.transform = 'translate3d(' + cx + 'px, ' + cy + 'px, 0) translate(-50%, -50%)';
                frameId = requestAnimationFrame(update);
            };

            window.addEventListener('mousemove', (e) => {
                mx = e.clientX;
                my = e.clientY;
            }, { passive: true });

            window.addEventListener('mouseleave', () => {
                cursor.style.opacity = '0';
            }, { passive: true });

            window.addEventListener('mouseenter', () => {
                cursor.style.opacity = '1';
            }, { passive: true });

            // Efectos de hover en elementos interactivos
            document.addEventListener('mouseover', (e) => {
                const target = e.target.closest('button, a, input, select, .interactive, .btn-kronos, .tab-btn');
                if (target) {
                    cursor.style.width = '38px';
                    cursor.style.height = '38px';
                    cursor.style.borderColor = 'var(--accent-magenta)';
                }
            }, { passive: true });

            document.addEventListener('mouseout', (e) => {
                const target = e.target.closest('button, a, input, select, .interactive, .btn-kronos, .tab-btn');
                if (target) {
                    cursor.style.width = '16px';
                    cursor.style.height = '16px';
                    cursor.style.borderColor = 'var(--accent-cyan)';
                }
            }, { passive: true });

            // Click effect
            window.addEventListener('mousedown', () => {
                cursor.style.transform += ' scale(0.75)';
                cursor.style.borderColor = 'var(--accent-gold)';
            }, { passive: true });

            window.addEventListener('mouseup', () => {
                cursor.style.transform = cursor.style.transform.replace(' scale(0.75)', '');
                cursor.style.borderColor = 'var(--accent-cyan)';
            }, { passive: true });

            update();
        },

        /**
         * Desactiva el cursor personalizado.
         */
        disable: function() {
            if (this._element) {
                this._element.remove();
                this._element = null;
            }
            this._enabled = false;
        }
    };

    // ============================================================
    // 3. SISTEMA DE LICENCIA SIMPLE
    // ============================================================

    window.CymaticLicense = {
        _storageKey: 'cymatic_licencia',

        /**
         * Obtiene la clave de licencia almacenada.
         * @returns {string|null}
         */
        get: function() {
            return localStorage.getItem(this._storageKey) || null;
        },

        /**
         * Almacena una clave de licencia.
         * @param {string} key
         */
        set: function(key) {
            localStorage.setItem(this._storageKey, key);
        },

        /**
         * Valida una clave de licencia (formato básico).
         * @param {string} key
         * @returns {boolean}
         */
        validate: function(key) {
            if (!key || typeof key !== 'string') return false;
            return key.startsWith('CYMATIC-') && key.length >= 10;
        },

        /**
         * Obtiene el tier (PRO, ULTRA, ENTERPRISE) desde la clave.
         * @param {string} key
         * @returns {string}
         */
        getTier: function(key) {
            if (!key) return 'NONE';
            if (key.includes('-PRO-')) return 'PRO';
            if (key.includes('-ULTRA-')) return 'ULTRA';
            if (key.includes('-ENT-') || key.includes('-ENTERPRISE-')) return 'ENTERPRISE';
            if (key.includes('-PERS-')) return 'PERSONAL';
            return 'UNKNOWN';
        }
    };

    // ============================================================
    // 4. INICIALIZACIÓN
    // ============================================================

    // Inicializar tema automáticamente
    document.addEventListener('DOMContentLoaded', function() {
        window.CymaticTheme.init();
        console.log('🎨 Tema inicializado:', window.CymaticTheme.get());
        console.log('🔑 Licencia:', window.CymaticLicense.get() || 'No activa');
    });

})();
