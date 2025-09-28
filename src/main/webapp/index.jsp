<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1"/>
  <title>MediStreet — Demo Pharmacy (single-file)</title>

  <style>
    :root {
      --bg:#f6f8fb; --card:#fff; --muted:#6b7280;
      --accent:#1f7a8c; --accent-2:#0b6b52; --danger:#dc2626;
      --shadow:0 6px 20px rgba(15,23,42,0.08);
      font-family: Inter, system-ui, Arial, sans-serif;
    }
    *{box-sizing:border-box}
    body {margin:0;background:var(--bg);color:#0f172a;line-height:1.45;-webkit-font-smoothing:antialiased}
    header {
      background:var(--card);box-shadow:var(--shadow);padding:12px 20px;
      display:flex;align-items:center;justify-content:space-between;gap:12px;flex-wrap:wrap;
      position:sticky;top:0;z-index:20;
    }
    .brand{display:flex;align-items:center;gap:12px}
    .logo{width:48px;height:48px;border-radius:10px;background:linear-gradient(135deg,var(--accent),var(--accent-2));display:flex;align-items:center;justify-content:center;color:white;font-weight:800;font-size:18px;box-shadow:0 8px 30px rgba(0,0,0,0.06)}
    .muted{color:var(--muted);font-size:13px}
    .controls{display:flex;align-items:center;gap:12px;flex-wrap:wrap}
    .search{background:#f8fafc;border-radius:10px;padding:8px 10px;display:flex;align-items:center;gap:8px;border:1px solid #e6eef2}
    .search input{border:0;background:transparent;outline:0;width:260px;font-size:14px}
    .pill{padding:6px 10px;border-radius:999px;background:#e6fffa;color:var(--accent-2);font-weight:700;cursor:pointer;border:1px solid #d1f5ef}
    .cart-mini{background:var(--card);padding:10px;border-radius:10px;box-shadow:var(--shadow);min-width:240px}
    .app{display:grid;grid-template-columns:280px 1fr;gap:20px;max-width:1200px;margin:20px auto;padding-bottom:40px}
    aside.panel{background:var(--card);padding:18px;border-radius:12px;box-shadow:var(--shadow);position:sticky;top:80px;height:calc(100vh - 120px);overflow:auto}
    main{min-height:200px}
    .toolbar{display:flex;justify-content:space-between;align-items:center;margin-bottom:12px;gap:12px}
    .products{display:grid;grid-template-columns:repeat(auto-fill,minmax(220px,1fr));gap:16px}
    .card{background:var(--card);padding:12px;border-radius:12px;box-shadow:var(--shadow);display:flex;flex-direction:column;gap:10px;min-height:200px}
    .card .img{width:100%;height:120px;border-radius:8px;overflow:hidden;display:flex;align-items:center;justify-content:center;background:#f3fafb}
    .card h4{margin:0;font-size:15px}
    .meta{font-size:13px;color:var(--muted)}
    .price{font-weight:800}
    .rx{font-size:11px;padding:4px 8px;border-radius:999px;background:#fff4e6;color:#92400e;border:1px solid #ffe2b4;margin-left:6px}
    .actions{display:flex;gap:8px;margin-top:auto;align-items:center}
    .btn{padding:8px 10px;border-radius:8px;border:0;cursor:pointer;background:var(--accent);color:white;font-weight:700}
    .btn.ghost{background:transparent;border:1px solid #e6eef2;color:var(--accent)}
    .cart-list{max-height:280px;overflow:auto;margin-top:8px}
    .cart-item{display:flex;gap:8px;align-items:center;padding:8px;border-radius:8px}
    .modal{position:fixed;inset:0;display:none;align-items:center;justify-content:center;background:rgba(2,6,23,0.45);z-index:60}
    .modal.open{display:flex}
    .sheet{width:760px;max-width:95%;background:var(--card);padding:18px;border-radius:12px;box-shadow:var(--shadow)}
    .grid-2{display:grid;grid-template-columns:1fr 320px;gap:14px}
    .footer-section{max-width:1200px;margin:20px auto 80px;display:grid;grid-template-columns:2fr 1fr;gap:20px}
    .box{background:var(--card);padding:12px;border-radius:12px;box-shadow:var(--shadow)}
    .small{font-size:13px;color:var(--muted)}
    @media(max-width:980px){
      .app{grid-template-columns:1fr}
      aside.panel{position:static;height:auto}
      .grid-2{grid-template-columns:1fr}
      .search input{width:140px}
    }
  </style>
</head>
<body>
  <header>
    <div class="brand" id="site-title">
      <div class="logo">MS</div>
      <div>
        <div style="font-size:16px;font-weight:700">MediStreet</div>
        <div class="muted">Trusted demo pharmacy • client-side demo</div>
      </div>
    </div>

    <div class="controls" role="toolbar" aria-label="Top controls">
      <div class="search" role="search" aria-label="Search medicines">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" aria-hidden><path d="M21 21l-4.35-4.35" stroke="#6b7280" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>
        <input id="searchInput" placeholder="Search medicines, e.g., paracetamol, cough" />
      </div>

      <div class="pill" id="prescFilterToggle" title="Toggle prescription-only items">RX: All</div>

      <div class="cart-mini" aria-live="polite" id="cartMini">
        <div style="display:flex;align-items:center;justify-content:space-between">
          <strong>Cart</strong>
          <button class="btn ghost" id="openCheckout">Checkout →</button>
        </div>
        <div class="cart-list" id="cartList">
          <div class="small">Cart is empty</div>
        </div>
      </div>
    </div>
  </header>

  <div class="app" role="application">
    <!-- SIDEBAR -->
    <aside class="panel" aria-label="Filters">
      <h3 style="margin:0 0 12px 0">Filters</h3>

      <div style="margin-bottom:12px">
        <div class="small">Categories</div>
        <div id="categoryFilters" style="display:flex;gap:8px;flex-wrap:wrap;margin-top:8px"></div>
      </div>

      <div style="margin-bottom:12px">
        <div class="small">Price range</div>
        <div style="display:flex;gap:8px;margin-top:8px">
          <input id="minPrice" type="number" placeholder="Min" style="width:100px;padding:8px;border-radius:8px;border:1px solid #e6eef2" />
          <input id="maxPrice" type="number" placeholder="Max" style="width:100px;padding:8px;border-radius:8px;border:1px solid #e6eef2" />
          <button class="btn ghost" id="applyPrice">Apply</button>
        </div>
      </div>

      <div style="margin-bottom:12px">
        <div class="small">Sort</div>
        <select id="sidebarSort" style="width:100%;margin-top:8px;padding:8px;border-radius:8px;border:1px solid #e6eef2">
          <option value="relevance">Relevance</option>
          <option value="price-asc">Price ↑</option>
          <option value="price-desc">Price ↓</option>
          <option value="expiry">Expiry soon</option>
        </select>
      </div>

      <div style="margin-top:18px">
        <h4 style="margin:0 0 6px 0">Store info</h4>
        <div class="small">Open: Mon–Sat 9:00–20:00</div>
        <div class="small">Avg delivery: 2–4 business days</div>
        <div style="margin-top:10px">
          <strong>Address</strong>
          <div class="small">Demo Lane, City, Country</div>
        </div>
      </div>

      <div style="margin-top:18px">
        <button class="btn" id="clearAll">Clear Filters</button>
      </div>
    </aside>

    <!-- MAIN AREA -->
    <main>
      <div class="toolbar">
        <div>
          <div id="resultsCount">Showing medicines</div>
          <div class="small">Pharmacist advice: this is a client-side demo; do not use for real prescriptions</div>
        </div>

        <div style="display:flex;gap:8px;align-items:center">
          <label class="small" for="perPage">Per page</label>
          <select id="perPage" style="padding:8px;border-radius:8px;border:1px solid #e6eef2">
            <option>12</option><option>24</option><option>48</option>
          </select>

          <label class="small" for="topSort">Sort</label>
          <select id="topSort" style="padding:8px;border-radius:8px;border:1px solid #e6eef2">
            <option value="relevance">Relevance</option>
            <option value="price-asc">Price ↑</option>
            <option value="price-desc">Price ↓</option>
            <option value="expiry">Expiry soon</option>
          </select>
        </div>
      </div>

      <section class="products" id="productsList" aria-live="polite"></section>

      <div id="noResults" style="display:none;padding:18px;background:var(--card);border-radius:12px;box-shadow:var(--shadow);margin-top:12px">
        <h3>No medicines found</h3>
        <div class="small">Try changing filters or search terms.</div>
      </div>
    </main>
  </div>

  <!-- CHECKOUT / CART MODAL -->
  <div id="checkoutModal" class="modal" aria-hidden="true">
    <div class="sheet" role="dialog" aria-modal="true" aria-label="Checkout and place order">
      <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:12px">
        <h3 style="margin:0">Checkout</h3>
        <div>
          <button class="btn ghost" id="closeCheckout">Close</button>
        </div>
      </div>

      <div class="grid-2">
        <div>
          <h4>Delivery details</h4>
          <form id="checkoutForm" novalidate>
            <div style="margin-bottom:8px">
              <label class="small">Full name</label><br/>
              <input required id="custName" style="width:100%;padding:10px;border-radius:8px;border:1px solid #e6eef2"/>
            </div>
            <div style="margin-bottom:8px">
              <label class="small">Phone</label><br/>
              <input required id="custPhone" style="width:100%;padding:10px;border-radius:8px;border:1px solid #e6eef2"/>
            </div>
            <div style="margin-bottom:8px">
              <label class="small">Address</label><br/>
              <textarea required id="custAddress" style="width:100%;padding:10px;border-radius:8px;border:1px solid #e6eef2" rows="3"></textarea>
            </div>

            <div style="margin-top:12px">
              <label class="small">Payment method</label><br/>
              <select id="paymentMethod" style="width:100%;padding:10px;border-radius:8px;border:1px solid #e6eef2">
                <option value="cod">Cash on delivery</option>
                <option value="card">Card (demo)</option>
              </select>
            </div>

            <div style="margin-top:12px;display:flex;gap:8px">
              <button type="submit" class="btn">Place Order</button>
              <button type="button" class="btn ghost" id="saveDraft">Save draft</button>
            </div>
          </form>
        </div>

        <aside style="background:linear-gradient(180deg,#ffffff,#fbfcfd);padding:12px;border-radius:8px">
          <h4 style="margin-top:0">Order summary</h4>
          <div id="orderSummary"></div>
          <div style="margin-top:12px;display:flex;justify-content:space-between">
            <div class="small">Subtotal</div>
            <div id="summarySubtotal">₹0</div>
          </div>
          <div style="margin-top:6px;display:flex;justify-content:space-between">
            <div class="small">Delivery</div>
            <div id="summaryDelivery">₹50</div>
          </div>
          <div style="margin-top:12px;display:flex;justify-content:space-between;font-weight:700">
            <div>Total</div>
            <div id="summaryTotal">₹0</div>
          </div>
          <div style="margin-top:10px;font-size:12px;color:var(--muted)">Orders are stored locally for demo purposes only.</div>
        </aside>
      </div>
    </div>
  </div>

  <!-- ORDERS & DEBUG -->
  <div class="footer-section">
    <div class="box">
      <h4 style="margin:0 0 8px 0">Your recent orders (client-side demo)</h4>
      <div id="ordersList" class="small">No orders yet</div>
    </div>

    <div class="box">
      <h4 style="margin:0 0 8px 0">Debug & Export</h4>
      <div style="display:flex;gap:8px">
        <button class="btn ghost" id="exportOrders">Export Orders</button>
        <button class="btn ghost" id="clearOrders">Clear Orders</button>
      </div>
    </div>
  </div>

  <!-- ===== INLINE SCRIPT (self-contained) ===== -->
  <script>
    /* ========== Inline SVG product images as data URIs ==========
       Using compact, inline SVGs -> no external image requests.
       Colors are encoded as %23... where necessary when using raw URI style.
    */

    const IMG = {
      P: 'data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="400" height="240"><rect width="100%" height="100%" rx="20" fill="%231f7a8c"/><text x="50%" y="50%" fill="white" font-family="Arial,Helvetica,sans-serif" font-weight="700" font-size="96" dominant-baseline="middle" text-anchor="middle">P</text></svg>',
      A: 'data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="400" height="240"><rect width="100%" height="100%" rx="20" fill="%230b6b52"/><text x="50%" y="50%" fill="white" font-family="Arial,Helvetica,sans-serif" font-weight="700" font-size="96" dominant-baseline="middle" text-anchor="middle">A</text></svg>',
      C: 'data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="400" height="240"><rect width="100%" height="100%" rx="20" fill="%237c3aed"/><text x="50%" y="50%" fill="white" font-family="Arial,Helvetica,sans-serif" font-weight="700" font-size="96" dominant-baseline="middle" text-anchor="middle">C</text></svg>',
      S: 'data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="400" height="240"><rect width="100%" height="100%" rx="20" fill="%23f97316"/><text x="50%" y="50%" fill="white" font-family="Arial,Helvetica,sans-serif" font-weight="700" font-size="96" dominant-baseline="middle" text-anchor="middle">S</text></svg>',
      I: 'data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="400" height="240"><rect width="100%" height="100%" rx="20" fill="%23ef4444"/><text x="50%" y="50%" fill="white" font-family="Arial,Helvetica,sans-serif" font-weight="700" font-size="96" dominant-baseline="middle" text-anchor="middle">I</text></svg>',
      M: 'data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="400" height="240"><rect width="100%" height="100%" rx="20" fill="%230ea5a4"/><text x="50%" y="50%" fill="white" font-family="Arial,Helvetica,sans-serif" font-weight="700" font-size="96" dominant-baseline="middle" text-anchor="middle">M</text></svg>',
      G: 'data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="400" height="240"><rect width="100%" height="100%" rx="20" fill="%23059669"/><text x="50%" y="50%" fill="white" font-family="Arial,Helvetica,sans-serif" font-weight="700" font-size="96" dominant-baseline="middle" text-anchor="middle">G</text></svg>',
      L: 'data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="400" height="240"><rect width="100%" height="100%" rx="20" fill="%230ea5ff"/><text x="50%" y="50%" fill="white" font-family="Arial,Helvetica,sans-serif" font-weight="700" font-size="96" dominant-baseline="middle" text-anchor="middle">L</text></svg>',
      O: 'data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="400" height="240"><rect width="100%" height="100%" rx="20" fill="%237c3aed"/><text x="50%" y="50%" fill="white" font-family="Arial,Helvetica,sans-serif" font-weight="700" font-size="96" dominant-baseline="middle" text-anchor="middle">O</text></svg>',
      H: 'data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="400" height="240"><rect width="100%" height="100%" rx="20" fill="%23f59e0b"/><text x="50%" y="50%" fill="white" font-family="Arial,Helvetica,sans-serif" font-weight="700" font-size="96" dominant-baseline="middle" text-anchor="middle">H</text></svg>'
    };

    /* ========== Sample medicine catalog (includes data URI images) ========== */
    const MEDICINES = [
      { id: 'm1', name: 'Paracetamol 500mg', brand: 'Acme Pharma', price: 49, category: 'Analgesic', stock: 120, rx: false, expiry: '2026-03-01', desc: 'Relieves pain & reduces fever.', img: IMG.P },
      { id: 'm2', name: 'Amoxicillin 500mg', brand: 'HealWell', price: 159, category: 'Antibiotic', stock: 40, rx: true, expiry: '2025-11-12', desc: 'Antibiotic for bacterial infections.', img: IMG.A },
      { id: 'm3', name: 'Cetirizine 10mg', brand: 'AllerFix', price: 89, category: 'Antihistamine', stock: 200, rx: false, expiry: '2027-07-21', desc: 'For allergy relief.', img: IMG.C },
      { id: 'm4', name: 'Salbutamol Inhaler', brand: 'AirCare', price: 499, category: 'Respiratory', stock: 15, rx: true, expiry: '2026-01-05', desc: 'Relieves bronchospasm.', img: IMG.S },
      { id: 'm5', name: 'Ibuprofen 200mg', brand: 'PainAway', price: 59, category: 'Analgesic', stock: 90, rx: false, expiry: '2025-09-30', desc: 'Anti-inflammatory and pain relief.', img: IMG.I },
      { id: 'm6', name: 'Multivitamin Syrup', brand: 'NutriPlus', price: 199, category: 'Supplements', stock: 60, rx: false, expiry: '2026-12-31', desc: 'Daily multivitamin for children.', img: IMG.M },
      { id: 'm7', name: 'Metformin 500mg', brand: 'GlucoCare', price: 129, category: 'Antidiabetic', stock: 50, rx: true, expiry: '2026-05-20', desc: 'For blood sugar control.', img: IMG.G },
      { id: 'm8', name: 'Loperamide 2mg', brand: 'DiarrSol', price: 69, category: 'GI', stock: 180, rx: false, expiry: '2027-02-15', desc: 'Helps relieve diarrhea.', img: IMG.L },
      { id: 'm9', name: 'Omeprazole 20mg', brand: 'GastroFix', price: 139, category: 'GI', stock: 100, rx: false, expiry: '2025-10-10', desc: 'For acid reflux and ulcers.', img: IMG.O },
      { id: 'm10', name: 'Hydrocortisone Cream 1%', brand: 'SkinCare', price: 149, category: 'Topical', stock: 70, rx: false, expiry: '2026-08-18', desc: 'For mild skin inflammation.', img: IMG.H }
    ];

    /* ====================== Utilities & App State ====================== */
    const qs = s => document.querySelector(s);
    const qsa = s => Array.from(document.querySelectorAll(s));
    const formatINR = n => '₹' + Number(n).toLocaleString('en-IN');

    let state = {
      medicines: MEDICINES.slice(),
      filters: { category: null, minPrice: null, maxPrice: null, rxOnly: null },
      sort: 'relevance',
      perPage: 12,
      search: '',
      cart: JSON.parse(localStorage.getItem('medi_cart') || '[]'),
      orders: JSON.parse(localStorage.getItem('medi_orders') || '[]'),
    };

    /* ====================== DOM refs ====================== */
    const productsList = qs('#productsList');
    const categoryFilters = qs('#categoryFilters');
    const searchInput = qs('#searchInput');
    const resultsCount = qs('#resultsCount');
    const cartList = qs('#cartList');
    const openCheckout = qs('#openCheckout');
    const checkoutModal = qs('#checkoutModal');
    const closeCheckout = qs('#closeCheckout');
    const checkoutForm = qs('#checkoutForm');
    const orderSummary = qs('#orderSummary');
    const summarySubtotal = qs('#summarySubtotal');
    const summaryDelivery = qs('#summaryDelivery');
    const summaryTotal = qs('#summaryTotal');
    const ordersList = qs('#ordersList');
    const exportOrders = qs('#exportOrders');
    const clearOrders = qs('#clearOrders');
    const prescFilterToggle = qs('#prescFilterToggle');

    /* ====================== Init ====================== */
    function init(){
      buildCategoryChips();
      attachListeners();
      renderProducts();
      renderCart();
      renderOrders();
    }

    /* ====================== Category chips ====================== */
    function buildCategoryChips(){
      const cats = Array.from(new Set(state.medicines.map(m => m.category)));
      categoryFilters.innerHTML = '';
      const allChip = document.createElement('div');
      allChip.className = 'chip';
      allChip.style.cursor = 'pointer';
      allChip.style.padding = '6px 10px';
      allChip.style.borderRadius = '999px';
      allChip.style.background = state.filters.category === null ? 'linear-gradient(90deg,var(--accent),var(--accent-2))' : '#f3f4f6';
      allChip.style.color = state.filters.category === null ? 'white' : 'initial';
      allChip.textContent = 'All';
      allChip.onclick = () => { state.filters.category = null; renderProducts(); buildCategoryChips(); };
      categoryFilters.appendChild(allChip);

      cats.forEach(c => {
        const el = document.createElement('div');
        el.className = 'chip';
        el.style.cursor = 'pointer';
        el.style.padding = '6px 10px';
        el.style.borderRadius = '999px';
        el.style.background = state.filters.category === c ? 'linear-gradient(90deg,var(--accent),var(--accent-2))' : '#f3f4f6';
        el.style.color = state.filters.category === c ? 'white' : 'initial';
        el.style.fontWeight = state.filters.category === c ? 700 : 500;
        el.textContent = c;
        el.onclick = () => { state.filters.category = (state.filters.category === c ? null : c); renderProducts(); buildCategoryChips(); };
        categoryFilters.appendChild(el);
      });
    }

    /* ====================== Filter + search ====================== */
    qs('#applyPrice').addEventListener('click', () => {
      const min = Number(qs('#minPrice').value || 0);
      const max = Number(qs('#maxPrice').value || 0);
      state.filters.minPrice = min>0 ? min : null;
      state.filters.maxPrice = max>0 ? max : null;
      renderProducts();
    });

    qs('#clearAll').addEventListener('click', () => {
      state.filters = { category: null, minPrice: null, maxPrice: null, rxOnly: null };
      qs('#minPrice').value = qs('#maxPrice').value = '';
      qs('#searchInput').value = '';
      state.search = '';
      renderProducts();
      buildCategoryChips();
    });

    searchInput.addEventListener('input', (e) => {
      state.search = e.target.value.trim().toLowerCase();
      renderProducts();
    });

    qs('#sidebarSort').addEventListener('change', (e) => { state.sort = e.target.value; renderProducts(); });
    qs('#topSort').addEventListener('change', (e) => { state.sort = e.target.value; renderProducts(); });
    qs('#perPage').addEventListener('change', (e) => { state.perPage = Number(e.target.value); renderProducts(); });

    prescFilterToggle.addEventListener('click', () => {
      state.filters.rxOnly = state.filters.rxOnly ? null : true;
      prescFilterToggle.textContent = state.filters.rxOnly ? 'RX: Required' : 'RX: All';
      renderProducts();
    });

    /* ====================== Render products ====================== */
    function renderProducts(){
      const filtered = state.medicines.filter(m => {
        if (state.filters.category && m.category !== state.filters.category) return false;
        if (state.filters.rxOnly && !m.rx) return false;
        if (state.filters.minPrice && m.price < state.filters.minPrice) return false;
        if (state.filters.maxPrice && m.price > state.filters.maxPrice) return false;
        if (state.search) {
          const s = state.search;
          const hay = (m.name + ' ' + m.brand + ' ' + m.category + ' ' + m.desc).toLowerCase();
          if (!hay.includes(s)) return false;
        }
        return true;
      });

      // sorting
      if (state.sort === 'price-asc') filtered.sort((a,b)=>a.price-b.price);
      else if (state.sort === 'price-desc') filtered.sort((a,b)=>b.price-a.price);
      else if (state.sort === 'expiry') filtered.sort((a,b)=> new Date(a.expiry) - new Date(b.expiry));

      // update results count
      resultsCount.textContent = `Showing ${filtered.length} medicines`;

      // render or fallback
      productsList.innerHTML = '';
      if (!filtered.length){
        qs('#noResults').style.display = 'block';
        return;
      } else {
        qs('#noResults').style.display = 'none';
      }

      const perPage = state.perPage || 12;
      const pageSlice = filtered.slice(0, perPage);

      pageSlice.forEach(m => {
        const el = document.createElement('article');
        el.className = 'card';
        el.innerHTML = `
          <div class="img" aria-hidden><img src="${m.img}" alt="${escapeHtml(m.name)}" style="width:100%;height:100%;object-fit:cover" /></div>
          <div>
            <h4>${escapeHtml(m.name)} ${m.rx ? '<span class="rx">Rx</span>' : ''}</h4>
            <div class="meta">${escapeHtml(m.brand)} • ${escapeHtml(m.category)}</div>
            <div class="price">${formatINR(m.price)} <span class="small" style="color:var(--muted);font-weight:600;margin-left:8px">${m.stock} in stock</span></div>
            <div class="small" style="margin-top:8px">${escapeHtml(m.desc)}</div>
          </div>
          <div class="actions">
            <button class="btn" data-add="${m.id}">Add</button>
            <button class="btn ghost" data-view="${m.id}">Quick</button>
          </div>
        `;
        productsList.appendChild(el);
      });

      // attach add/view handlers
      qsa('[data-add]').forEach(btn => btn.onclick = () => addToCart(btn.getAttribute('data-add')));
      qsa('[data-view]').forEach(btn => btn.onclick = () => quickView(btn.getAttribute('data-view')));
    }

    /* ====================== Quick view ====================== */
    function quickView(id){
      const m = state.medicines.find(x=>x.id===id);
      if(!m) return alert('Not found');
      // small quick modal: using window.prompt as quick demo — replace with custom modal if you want
      alert(`${m.name}\n\n${m.desc}\n\nBrand: ${m.brand}\nPrice: ${formatINR(m.price)}\nRx Required: ${m.rx ? 'Yes' : 'No'}\nExpiry: ${m.expiry}`);
    }

    /* ====================== Cart logic ====================== */
    function addToCart(id){
      const med = state.medicines.find(m=>m.id===id);
      if(!med) return;
      const existing = state.cart.find(i=>i.id===id);
      if(existing){
        if(existing.qty < med.stock) existing.qty += 1;
      } else {
        state.cart.push({ id: med.id, name: med.name, price: med.price, qty: 1, rx: med.rx });
      }
      persistCart();
      renderCart();
    }

    function changeQty(id, delta){
      const it = state.cart.find(i=>i.id===id);
      if(!it) return;
      it.qty += delta;
      if(it.qty <= 0) state.cart = state.cart.filter(i=>i.id !== id);
      persistCart();
      renderCart();
    }

    function removeFromCart(id){
      state.cart = state.cart.filter(i=>i.id !== id);
      persistCart();
      renderCart();
    }

    function persistCart(){
      localStorage.setItem('medi_cart', JSON.stringify(state.cart));
    }

    function renderCart(){
      if(!state.cart.length){
        cartList.innerHTML = '<div class="small">Cart is empty</div>';
        summarySubtotal.textContent = formatINR(0);
        summaryTotal.textContent = formatINR(0);
        orderSummary.innerHTML = '<div class="small">No items</div>';
        return;
      }
      cartList.innerHTML = '';
      let subtotal = 0;
      state.cart.forEach(item=>{
        subtotal += item.price * item.qty;
        const row = document.createElement('div');
        row.className = 'cart-item';
        row.innerHTML = `
          <div style="width:48px;height:48px;border-radius:8px;background:#f3faf9;display:flex;align-items:center;justify-content:center">${escapeHtml(item.name.slice(0,2))}</div>
          <div style="flex:1">
            <div style="display:flex;justify-content:space-between;align-items:center">
              <div><strong style="font-size:14px">${escapeHtml(item.name)}</strong><div class="small">${item.qty} × ${formatINR(item.price)}</div></div>
              <div style="display:flex;flex-direction:column;gap:6px;align-items:flex-end">
                <div style="display:flex;gap:6px;align-items:center">
                  <button class="btn ghost" data-dec="${item.id}">−</button>
                  <div class="small">${item.qty}</div>
                  <button class="btn ghost" data-inc="${item.id}">+</button>
                </div>
                <button class="btn ghost" data-remove="${item.id}">Remove</button>
              </div>
            </div>
          </div>
        `;
        cartList.appendChild(row);
      });

      // attach handlers
      qsa('[data-inc]').forEach(b=>b.onclick = ()=> changeQty(b.getAttribute('data-inc'), 1));
      qsa('[data-dec]').forEach(b=>b.onclick = ()=> changeQty(b.getAttribute('data-dec'), -1));
      qsa('[data-remove]').forEach(b=>b.onclick = ()=> removeFromCart(b.getAttribute('data-remove')));

      // summary in modal
      summarySubtotal.textContent = formatINR(subtotal);
      const delivery = subtotal > 499 ? 0 : 50;
      summaryDelivery.textContent = formatINR(delivery);
      summaryTotal.textContent = formatINR(subtotal + delivery);

      orderSummary.innerHTML = state.cart.map(it=>`<div style="display:flex;justify-content:space-between;padding:6px 0"><div>${escapeHtml(it.name)} × ${it.qty}</div><div>${formatINR(it.price * it.qty)}</div></div>`).join('');
    }

    /* ====================== Orders ====================== */
    checkoutForm.addEventListener('submit', (e) => {
      e.preventDefault();
      if(!state.cart.length) return alert('Cart empty');
      const name = qs('#custName').value.trim();
      const phone = qs('#custPhone').value.trim();
      const address = qs('#custAddress').value.trim();
      if(!name || !phone || !address) return alert('Please fill required fields');
      const order = {
        id: 'ORD' + Date.now(),
        date: new Date().toISOString(),
        items: state.cart.map(c => ({ id:c.id, name:c.name, qty:c.qty, price:c.price, rx:c.rx })),
        subtotal: Number((state.cart.reduce((s,i)=>s+i.price*i.qty,0)).toFixed(2)),
        delivery: state.cart.reduce((s,i)=>s+i.price*i.qty,0) > 499 ? 0 : 50,
        total: 0,
        customer: { name, phone, address, note: qs('#custNote') ? qs('#custNote').value : '' },
        payment: qs('#paymentMethod').value
      };
      order.total = order.subtotal + order.delivery;
      state.orders.unshift(order);
      localStorage.setItem('medi_orders', JSON.stringify(state.orders));
      // clear cart
      state.cart = [];
      localStorage.setItem('medi_cart', JSON.stringify(state.cart));
      renderCart();
      renderOrders();
      checkoutModal.classList.remove('open');
      alert('Order placed (demo). Order id: ' + order.id + '\n(Orders stored locally in browser)');
    });

    qs('#saveDraft').addEventListener('click', ()=>{
      localStorage.setItem('medi_cart', JSON.stringify(state.cart));
      alert('Cart saved as draft locally.');
    });

    function renderOrders(){
      if(!state.orders.length){
        ordersList.innerHTML = '<div class="small">No orders yet</div>';
        return;
      }
      ordersList.innerHTML = state.orders.slice(0,8).map(o=>`
        <div style="display:flex;justify-content:space-between;padding:8px 0;border-bottom:1px dashed #eef3f6">
          <div>
            <strong>${escapeHtml(o.id)}</strong>
            <div class="small">${(new Date(o.date)).toLocaleString()}</div>
            <div class="small">${o.items.length} items • ${escapeHtml(o.customer.name || '—')}</div>
          </div>
          <div style="text-align:right">
            <div style="font-weight:700">${formatINR(o.total)}</div>
            <div class="small">${escapeHtml(o.payment)}</div>
          </div>
        </div>
      `).join('');
    }

    exportOrders.addEventListener('click', ()=>{
      if(!state.orders.length) return alert('No orders to export');
      const data = JSON.stringify(state.orders, null, 2);
      const blob = new Blob([data], { type: 'application/json' });
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url; a.download = 'medi_orders_' + (new Date().toISOString().slice(0,10)) + '.json';
      document.body.appendChild(a); a.click(); a.remove();
      URL.revokeObjectURL(url);
    });

    clearOrders.addEventListener('click', ()=>{
      if(!confirm('Clear all local orders?')) return;
      state.orders = [];
      localStorage.setItem('medi_orders', JSON.stringify(state.orders));
      renderOrders();
    });

    /* ====================== Modal handlers ====================== */
    openCheckout.addEventListener('click', ()=>{
      checkoutModal.classList.add('open');
      checkoutModal.setAttribute('aria-hidden','false');
      renderCart();
    });
    closeCheckout.addEventListener('click', ()=>{
      checkoutModal.classList.remove('open');
      checkoutModal.setAttribute('aria-hidden','true');
    });
    checkoutModal.addEventListener('click', (e)=>{
      if(e.target === checkoutModal) { checkoutModal.classList.remove('open'); checkoutModal.setAttribute('aria-hidden','true'); }
    });

    /* ====================== Small helpers ====================== */
    function escapeHtml(str){
      if(!str && str !== 0) return '';
      return String(str)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#039;');
    }

    /* ====================== Init on load ====================== */
    init();
    console.log('MediStreet demo loaded with embedded SVG images. LocalStorage keys: medi_cart, medi_orders');
  </script>
</body>
</html>

