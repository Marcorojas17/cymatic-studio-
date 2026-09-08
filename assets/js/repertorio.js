/**
 * ============================================================
 * CYMATIC STUDIO v24 · REPERTORIO LOGIC
 * Navegación entre versiones, efectos de sonido y UI.
 * ============================================================
 */

(function() {
    'use strict';

    // ============================================================
    // 1. DATOS DE VERSIONES (para vista de demo)
    // ============================================================

    const VERSION_DATA = {
        'v1.0': { title: 'Quantum Seed', tag: 'free', price: 'Gratis' },
        'v3.0': { title: 'Cymatic Core', tag: 'pro', price: '$19 USD' },
        'v8.0': { title: 'Quantum Bloom', tag: 'pro', price: '$79 USD' },
        'v15.0': { title: 'Omni-Sensory', tag: 'ultra', price: '$249 USD' },
        'v21.5': { title: 'Singular Quantum', tag: 'enterprise', price: '$499 USD' },
        'v24': { title: 'Quantum Core', tag: 'enterprise', price: '$749 USD' }
    };

    // ============================================================
    // 2. FUNCIONES DE NAVEGACIÓN
    // ============================================================

    /**
     * Abre una versión en la vista de demo (si existe el contenedor).
     * @param {string} versionId - 'v1.0', 'v3.0', etc.
     */
    window.abrirVersion = function(versionId) {
        const data = VERSION_DATA[versionId];
        if (!data) {
            console.warn('Versión no encontrada:', versionId);
            return;
        }

        const grid = document.getElementById('versionGrid');
        const demo = document.getElementById('demoView');
        const btnBack = document.getElementById('btnBack');

        if (!grid || !demo || !btnBack) {
            // Si no hay vista de demo, redirigir a la versión real
            window.location.href = 'versions/cymatic_' + versionId + '.html';
            return;
        }

        // Ocultar grid, mostrar demo
        grid.style.display = 'none';
        demo.style.display = 'block';
        demo.classList.add('active');
        btnBack.classList.remove('hidden');

        // Llenar contenido
        document.getElementById('demoTitle').textContent = data.title + ' · ' + versionId.toUpperCase();
        const content = document.getElementById('demoContent');
        content.innerHTML = `
            <p><strong>Versión:</strong> ${versionId}</p>
            <p><strong>Tipo:</strong> ${data.tag.toUpperCase()}</p>
            <p><strong>Precio:</strong> ${data.price}</p>
            <div style="margin-top:20px; padding:20px; background:rgba(0,0,0,0.2); border-radius:var(--radius-md); text-align:center; color:var(--text-tertiary);">
                🎨 Demo interactiva de ${data.title}
            </div>
            <div style="margin-top:16px; text-align:center;">
                <a href="versions/cymatic_${versionId}.html" target="_blank" class="btn-open" style="display:inline-block; width:auto; padding:12px 32px;">
                    🚀 Abrir versión completa
                </a>
            </div>
        `;

        // Reproducir sonido de apertura
        if (typeof playUiChime === 'function') {
            playUiChime('open');
        }

        // Scroll al inicio de la demo
        demo.scrollIntoView({ behavior: 'smooth', block: 'start' });
    };

    /**
     * Vuelve al grid de versiones desde la vista de demo.
     */
    window.goBack = function() {
        const grid = document.getElementById('versionGrid');
        const demo = document.getElementById('demoView');
        const btnBack = document.getElementById('btnBack');

        if (grid && demo && btnBack) {
            grid.style.display = 'grid';
            demo.style.display = 'none';
            demo.classList.remove('active');
            btnBack.classList.add('hidden');
            if (typeof playUiChime === 'function') {
                playUiChime('click');
            }
            // Scroll al grid
            grid.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
    };

    // ============================================================
    // 3. INICIALIZACIÓN DE EVENTOS UI
    // ============================================================

    document.addEventListener('DOMContentLoaded', function() {
        // Efectos de hover en tarjetas (opcional, ya está en CSS)
        // Se puede añadir lógica adicional si se desea

        // Exponer funciones para uso en HTML
        window.VERSION_DATA = VERSION_DATA;
        console.log('📦 Repertorio inicializado. Versiones:', Object.keys(VERSION_DATA).join(', '));
    });

})();
