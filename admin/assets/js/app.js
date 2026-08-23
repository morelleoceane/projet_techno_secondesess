/**
 * app.js – ModeShopping TI2
 * Toutes les opérations JavaScript/AJAX du site sont ICI.
 * CORRECTION : aucun <script> inline dans les fichiers PHP.
 *              Tous les scripts sont centralisés dans ce fichier.
 * Utilise l'API Fetch (programmation asynchrone avec async/await).
 */

/* ============================================================
   UTILITAIRES
   ============================================================ */

function showToast(message, type = 'success') {
    let container = document.getElementById('toast-container');
    if (!container) {
        container = document.createElement('div');
        container.id = 'toast-container';
        document.body.appendChild(container);
    }
    const toast = document.createElement('div');
    toast.className = `toast-msg ${type}`;
    toast.textContent = message;
    container.appendChild(toast);
    setTimeout(() => toast.remove(), 3200);
}

function setLoader(visible) {
    let loader = document.getElementById('ajax-loader');
    if (!loader) {
        loader = document.createElement('div');
        loader.id = 'ajax-loader';
        document.body.prepend(loader);
    }
    loader.style.display = visible ? 'block' : 'none';
}

/* ============================================================
   1. RECHERCHE EN TEMPS REEL (AJAX Fetch asynchrone)
   ============================================================ */
function initRechercheAjax() {
    const input  = document.getElementById('rechercheAjax');
    const grille = document.getElementById('grille-articles');
    if (!input || !grille) return;

    let timeout;
    input.addEventListener('input', function () {
        clearTimeout(timeout);
        const q = this.value.trim();
        timeout = setTimeout(async () => {
            setLoader(true);
            try {
                const r    = await fetch('/ProjetMYTechno/admin/src/php/ajax/recherche_articles.php?q=' + encodeURIComponent(q));
                const data = await r.json();
                grille.innerHTML = '';
                if (data.length === 0) {
                    grille.innerHTML = '<div class="col-12"><div class="alert alert-info">Aucun article trouvé.</div></div>';
                } else {
                    data.forEach(a => {
                        grille.innerHTML += `
                        <div class="col-6 col-md-4">
                            <div class="card h-100 shadow-sm article-card">
                                <img src="/ProjetMYTechno/admin/assets/images/${a.photo_principale}"
                                     class="card-img-top article-img"
                                     data-fallback="/ProjetMYTechno/admin/assets/images/no_image.jpg"
                                     style="height:200px;object-fit:cover;"
                                     alt="${a.libelle}">
                                <div class="card-body d-flex flex-column">
                                    <h6 class="card-title">${a.libelle}</h6>
                                    <p class="text-muted small">${a.marque || '—'} | T.${a.taille || '—'}</p>
                                    <p class="fw-bold text-success fs-5 mt-auto">${parseFloat(a.prix_unitaire).toFixed(2)} €</p>
                                    <a href="/ProjetMYTechno/index_.php?page=article_detail&id=${a.id_article}"
                                       class="btn btn-dark btn-sm mt-2">Voir le produit</a>
                                </div>
                            </div>
                        </div>`;
                    });
                    initArticleImageFallback();
                }
                const counter = document.querySelector('.article-count');
                if (counter) counter.textContent = `(${data.length} article(s))`;
            } catch {
                showToast('Erreur lors de la recherche', 'error');
            } finally {
                setLoader(false);
            }
        }, 400);
    });
}

/* ============================================================
   2. TABLEAU EDITABLE Admin (Fetch asynchrone)
   ============================================================ */
function initTableauEditable() {
    document.querySelectorAll('.editable-cell').forEach(cell => {
        cell.setAttribute('contenteditable', 'true');
        cell.setAttribute('title', 'Cliquez pour modifier, Entrée pour valider');
        cell.dataset.original = cell.textContent.trim();

        cell.addEventListener('blur', async function () {
            const idArticle = this.dataset.id;
            const champ     = this.dataset.champ;
            const valeur    = this.textContent.trim();
            if (!idArticle || !champ || valeur === this.dataset.original) return;

            setLoader(true);
            try {
                const r    = await fetch('/ProjetMYTechno/admin/src/php/ajax/update_article.php', {
                    method : 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body   : `id_article=${idArticle}&champ=${champ}&valeur=${encodeURIComponent(valeur)}`
                });
                const data = await r.json();
                if (data.success) {
                    this.dataset.original = valeur;
                    showToast('Mis à jour avec succès');
                } else {
                    this.textContent = this.dataset.original;
                    showToast('Erreur : ' + (data.message || 'Mise à jour échouée'), 'error');
                }
            } catch {
                this.textContent = this.dataset.original;
                showToast('Erreur réseau', 'error');
            } finally {
                setLoader(false);
            }
        });

        cell.addEventListener('keydown', function (e) {
            if (e.key === 'Enter')  { e.preventDefault(); this.blur(); }
            if (e.key === 'Escape') { this.textContent = this.dataset.original; this.blur(); }
        });
    });
}

/* ============================================================
   3. VERIFICATION CODE PROMO (Fetch asynchrone)
   ============================================================ */
function initVerifPromo() {
    const btn    = document.getElementById('btn-verif-promo');
    const input  = document.getElementById('input-code-promo');
    const result = document.getElementById('promo-result');
    if (!btn || !input || !result) return;

    btn.addEventListener('click', async function () {
        const code = input.value.trim();
        if (!code) { showToast('Saisissez un code promo', 'error'); return; }
        setLoader(true);
        try {
            const r    = await fetch('/ProjetMYTechno/admin/src/php/ajax/verif_promo.php?code=' + encodeURIComponent(code));
            const data = await r.json();
            if (data.valide) {
                result.innerHTML = `<span class="badge bg-success">Code valide – remise de ${data.taux}%</span>`;
                showToast(`Code promo appliqué : -${data.taux}%`);
            } else {
                result.innerHTML = `<span class="badge bg-danger">Code invalide</span>`;
                showToast('Code promo invalide', 'error');
            }
        } catch {
            showToast('Erreur de vérification', 'error');
        } finally {
            setLoader(false);
        }
    });
}

/* ============================================================
   4. CONFIRMATION SUPPRESSION (modale Bootstrap)
   ============================================================ */
function initDeleteConfirm() {
    if (!document.getElementById('modalConfirmDelete')) {
        document.body.insertAdjacentHTML('beforeend', `
        <div class="modal fade" id="modalConfirmDelete" tabindex="-1">
            <div class="modal-dialog modal-sm modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header bg-danger text-white">
                        <h5 class="modal-title">Confirmer</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body text-center" id="modal-confirm-msg">Êtes-vous sûr(e) ?</div>
                    <div class="modal-footer justify-content-center">
                        <button id="btn-confirm-ok" class="btn btn-danger">Oui, supprimer</button>
                        <button class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    </div>
                </div>
            </div>
        </div>`);
    }
    const modal    = new bootstrap.Modal(document.getElementById('modalConfirmDelete'));
    const btnOk    = document.getElementById('btn-confirm-ok');
    const msgEl    = document.getElementById('modal-confirm-msg');
    let targetHref = null;

    document.querySelectorAll('[data-confirm]').forEach(link => {
        link.addEventListener('click', function (e) {
            e.preventDefault();
            targetHref        = this.href;
            msgEl.textContent = this.dataset.confirm || 'Confirmer la suppression ?';
            modal.show();
        });
    });
    btnOk.addEventListener('click', () => {
        if (targetHref) window.location.href = targetHref;
        modal.hide();
    });
}

/* ============================================================
   5. COMPTEUR PANIER (Fetch asynchrone)
   ============================================================ */
async function updateCartBadge() {
    try {
        const r    = await fetch('/ProjetMYTechno/admin/src/php/ajax/panier_count.php');
        const data = await r.json();
        document.querySelectorAll('.cart-badge').forEach(b => {
            b.textContent   = data.count;
            b.style.display = data.count > 0 ? 'inline-block' : 'none';
        });
    } catch { /* silencieux */ }
}

/* ============================================================
   6. FALLBACK IMAGE ARTICLE
   CORRECTION : était en <script> inline dans les pages PHP.
   ============================================================ */
function initArticleImageFallback() {
    document.querySelectorAll('.article-img').forEach(img => {
        img.addEventListener('error', function () {
            if (this.dataset.fallback) this.src = this.dataset.fallback;
        });
    });
}

/* ============================================================
   7. RECALCUL EN DIRECT DU PANIER
   CORRECTION : était en <script> inline dans panier.php.
   ============================================================ */
function initPanierLiveTotal() {
    document.querySelectorAll('input[name^="quantite"]').forEach(input => {
        input.addEventListener('input', function () {
            const row  = this.closest('tr');
            const prix = parseFloat(row.querySelector('[data-prix]').dataset.prix);
            const qty  = Math.max(1, parseInt(this.value) || 1);
            row.querySelector('.sous-total-ligne').textContent = (prix * qty).toFixed(2) + ' €';

            let total = 0;
            document.querySelectorAll('.sous-total-ligne').forEach(td => {
                total += parseFloat(td.textContent);
            });
            const tauxEl = document.querySelector('[data-taux]');
            const taux   = tauxEl ? parseFloat(tauxEl.dataset.taux) : 0;
            const remise = total * taux / 100;

            document.getElementById('sous-total').textContent  = total.toFixed(2) + ' €';
            document.getElementById('total-final').textContent = (total - remise).toFixed(2) + ' €';
            const remiseEl = document.getElementById('remise-affichee');
            if (remiseEl) remiseEl.textContent = remise.toFixed(2);
        });
    });
}

/* ============================================================
   INITIALISATION
   ============================================================ */
document.addEventListener('DOMContentLoaded', function () {
    initRechercheAjax();
    initTableauEditable();
    initVerifPromo();
    initDeleteConfirm();
    initArticleImageFallback();
    initPanierLiveTotal();

    updateCartBadge();
    setInterval(updateCartBadge, 30000);

    document.querySelectorAll('.alert:not(.alert-permanent)').forEach(alert => {
        setTimeout(() => {
            alert.style.transition = 'opacity .5s';
            alert.style.opacity    = '0';
            setTimeout(() => alert.remove(), 500);
        }, 4000);
    });
});
