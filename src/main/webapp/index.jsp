<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>MediStreet — Full Demo Pharmacy (single-file)</title>

  <style>
    /* ---------- Visual system & layout ---------- */
    :root{
      --bg:#f6f8fb; --card:#ffffff; --muted:#6b7280;
      --accent:#1f7a8c; --accent-2:#0b6b52; --danger:#dc2626;
      --shadow: 0 8px 30px rgba(15,23,42,0.06);
      --radius:12px;
      font-family: Inter, system-ui, "Segoe UI", Roboto, "Helvetica Neue", Arial;
      font-size:14px;
    }
    *{box-sizing:border-box}
    body{margin:0;background:linear-gradient(180deg,#f9fbfc,var(--bg));color:#0f172a;-webkit-font-smoothing:antialiased}
    a{color:inherit}
    .container{max-width:1200px;margin:18px auto;padding:0 18px}

    /* Header */
    header.app-header{
      background:var(--card);
      border-radius:var(--radius);
      box-shadow:var(--shadow);
      padding:12px 18px;
      display:flex;
      align-items:center;
      justify-content:space-between;
      gap:12px;
      position:sticky;top:12px;z-index:40;
    }
    .brand{display:flex;align-items:center;gap:12px}
    .logo{
      width:48px;height:48px;border-radius:10px;
      background:linear-gradient(135deg,var(--accent),var(--accent-2));
      display:flex;align-items:center;justify-content:center;color:white;font-weight:800;
      font-size:18px;box-shadow:0 8px 30px rgba(0,0,0,0.06)
    }
    .brand .titles{line-height:1}
    .brand h1{margin:0;font-size:16px}
    .brand .subtitle{font-size:12px;color:var(--muted)}

    .top-controls{display:flex;gap:12px;align-items:center;flex-wrap:wrap}
    .search{display:flex;align-items:center;gap:8px;background:#f8fbfb;border-radius:10px;padding:8px;border:1px solid #e6eef2}
    .search input{border:0;outline:0;background:transparent;width:280px;font-size:14px}
    .pill{padding:6px 10px;border-radius:999px;background:#e6fffa;color:var(--accent-2);font-weight:700;cursor:pointer;border:1px solid #d1f5ef}
    .cart-mini{min-width:260px;background:var(--card);padding:8px;border-radius:8px;box-shadow:var(--shadow)}

    /* App grid */
    .app-grid{display:grid;grid-template-columns:280px 1fr;gap:20px;margin-top:18px}
    aside.filters{
      background:var(--card);padding:16px;border-radius:var(--radius);box-shadow:var(--shadow);height:calc(100vh - 120px);overflow:auto;position:sticky;top:80px;
    }
    main.content{min-height:400px}

    /* Sidebar content */
    .chip{display:inline-block;padding:6px 10px;border-radius:999px;background:#f3f4f6;margin:6px 6px 0 0;cursor:pointer;font-weight:600}
    .chip.active{background:linear-gradient(90deg,var(--accent),var(--accent-2));color:white}

    /* Toolbar */
    .toolbar{display:flex;justify-content:space-between;align-items:center;gap:12px;margin-bottom:12px;flex-wrap:wrap}
    .toolbar-left{display:flex;flex-direction:column}
    .toolbar-right{display:flex;align-items:center;gap:8px}

    select,input[type=number]{padding:8px;border-radius:8px;border:1px solid #e6eef2}

    /* Product grid */
    .products{display:grid;grid-template-columns:repeat(auto-fill,minmax(220px,1fr));gap:16px}
    .card{background:var(--card);padding:12px;border-radius:10px;box-shadow:var(--shadow);display:flex;flex-direction:column;min-height:220px}
    .badge{width:100%;height:120px;border-radius:8px;display:flex;align-items:center;justify-content:center;font-size:48px;font-weight:800;color:white}
    .card h4{margin:8px 0 6px 0;font-size:15px}
    .meta{font-size:13px;color:var(--muted)}
    .price{font-weight:800;margin-top:6px}
    .rx{font-size:11px;padding:4px 8px;border-radius:999px;background:#fff4e6;color:#92400e;border:1px solid #ffe2b4;margin-left:6px}
    .actions{display:flex;gap:8px;margin-top:auto;align-items:center}

    /* Cart list */
    .cart-list{max-height:240px;overflow:auto;margin-top:8px}
    .cart-item{display:flex;gap:8px;align-items:center;padding:8px;border-radius:8px;border:1px solid #f1f5f9}

    /* Modal */
    .modal{position:fixed;inset:0;display:none;align-items:center;justify-content:center;background:rgba(0,0,0,0.45);z-index:80}
    .modal.open{display:flex}
    .sheet{width:820px;max-width:95%;background:var(--card);padding:18px;border-radius:12px;box-shadow:var(--shadow)}
    .grid-2{display:grid;grid-template-columns:1fr 320px;gap:14px}

    /* Footer / orders */
    .footer{display:grid;grid-template-columns:2fr 1fr;gap:16px;margin-top:18px}
    .box{background:var(--card);padding:12px;border-radius:10px;box-shadow:var(--shadow)}

    /* Tiny responsive */
    @media (max-width:980px){
      .app-grid{grid-template-columns:1fr}
      aside.filters{position:static;height:auto;top:auto}
      .search input{width:140px}
      .sheet{width:94%}
    }
  </style>
</head>
<body>
  <div class="container">
    <!-- HEADER -->
    <header class="app-header" role="banner">
      <div class="brand">
        <div class="logo">MS</div>
        <div class="titles">
          <h1>MediStreet</h1>
          <div class="subtitle">Trusted demo pharmacy • client-side demo</div>
        </div>
      </div>

      <div class="top-controls" role="toolbar" aria-label="Top controls">
        <div class="search" role="search">
          <svg width="16" height="16" viewBox="0 0 24 24" aria-hidden><path d="M21 21l-4.35-4.35" stroke="#6b7280" stroke-width="2" stroke-linecap="round"/></svg>
          <input id="searchInput" placeholder="Search medicines, e.g., paracetamol, cough" />
        </div>

        <div class="pill" id="prescFilterToggle" title="Toggle prescription-only">RX: All</div>

        <div class="cart-mini" id="cartMini" aria-live="polite">
          <div style="display:flex;justify-content:space-between;align-items:center">
            <strong>Cart</strong>
            <div style="display:flex;gap:6px;align-items:center">
              <button class="btn ghost" id="openCheckout">Checkout</button>
              <button class="btn ghost" id="openAdmin">Admin</button>
            </div>
          </div>
          <div class="cart-list" id="cartList">
            <div class="meta small">Cart is empty</div>
          </div>
        </div>
      </div>
    </header>

    <!-- APP GRID -->
    <div class="app-grid" role="main">
      <!-- SIDEBAR FILTERS -->
      <aside class="filters" aria-label="Filters">
        <h3 style="margin:0 0 8px 0">Filters</h3>

        <div style="margin-bottom:12px">
          <div class="meta">Categories</div>
          <div id="categoryFilters" style="margin-top:8px"></div>
        </div>

        <div style="margin-bottom:12px">
          <div class="meta">Price range</div>
          <div style="display:flex;gap:8px;margin-top:8px">
            <input id="minPrice" type="number" placeholder="Min" />
            <input id="maxPrice" type="number" placeholder="Max" />
            <button class="btn ghost" id="applyPrice">Apply</button>
          </div>
        </div>

        <div style="margin-bottom:12px">
          <div class="meta">Sort</div>
          <select id="sidebarSort" style="width:100%;margin-top:8px">
            <option value="relevance">Relevance</option>
            <option value="price-asc">Price ↑</option>
            <option value="price-desc">Price ↓</option>
            <option value="expiry">Expiry soon</option>
          </select>
        </div>

        <div style="margin-top:16px;display:flex;flex-direction:column;gap:8px">
          <button class="btn" id="clearAll">Clear Filters</button>
          <button class="btn ghost" id="exportCatalog">Export Catalog</button>
          <label class="btn ghost" style="display:inline-block;cursor:pointer">
            Import Catalog
            <input id="importCatalog" type="file" accept="application/json" style="display:none" />
          </label>
        </div>
      </aside>

      <!-- MAIN CONTENT -->
      <main class="content">
        <div class="toolbar">
          <div class="toolbar-left">
            <div id="resultsCount" class="meta">Showing medicines</div>
            <div class="meta">Pharmacist advice: demo only — do not use as real medical advice</div>
          </div>

          <div class="toolbar-right">
            <label class="meta">Per page
              <select id="perPage" style="margin-left:8px">
                <option>6</option><option>12</option><option>24</option>
              </select>
            </label>

            <label class="meta">Sort
              <select id="topSort" style="margin-left:8px">
                <option value="relevance">Relevance</option>
                <option value="price-asc">Price ↑</option>
                <option value="price-desc">Price ↓</option>
                <option value="expiry">Expiry soon</option>
              </select>
            </label>
          </div>
        </div>

        <section id="productsList" class="products" aria-live="polite"></section>

        <!-- Pagination / Load more -->
        <div style="display:flex;justify-content:center;align-items:center;gap:8px;margin-top:16px">
          <button class="btn ghost" id="prevPage">Prev</button>
          <div class="meta" id="pageInfo">Page 1</div>
          <button class="btn ghost" id="nextPage">Next</button>
          <button class="btn" id="loadMore">Load more</button>
        </div>
      </main>
    </div>

    <!-- CHECKOUT MODAL -->
    <div id="checkoutModal" class="modal" aria-hidden="true">
      <div class="sheet" role="dialog" aria-modal="true" aria-label="Checkout">
        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:12px">
          <h3 style="margin:0">Checkout</h3>
          <div>
            <button class="btn ghost" id="closeCheckout">Close</button>
          </div>
        </div>

        <div class="grid-2">
          <div>
            <form id="checkoutForm" novalidate>
              <div style="margin-bottom:8px">
                <label class="meta">Full name</label><br/>
                <input required id="custName" style="width:100%;padding:8px;border-radius:8px;border:1px solid #e6eef2"/>
              </div>
              <div style="margin-bottom:8px">
                <label class="meta">Phone</label><br/>
                <input required id="custPhone" style="width:100%;padding:8px;border-radius:8px;border:1px solid #e6eef2"/>
              </div>
              <div style="margin-bottom:8px">
                <label class="meta">Address</label><br/>
                <textarea required id="custAddress" style="width:100%;padding:8px;border-radius:8px;border:1px solid #e6eef2" rows="3"></textarea>
              </div>
              <div style="display:flex;gap:8px">
                <button type="submit" class="btn">Place order</button>
                <button type="button" class="btn ghost" id="saveDraft">Save draft</button>
              </div>
            </form>
          </div>

          <aside>
            <h4 style="margin-top:0">Order summary</h4>
            <div id="orderSummary" style="min-height:100px"></div>
            <div style="margin-top:12px;display:flex;justify-content:space-between">
              <div class="meta">Subtotal</div>
              <div id="summarySubtotal" class="meta">₹0</div>
            </div>
            <div style="margin-top:6px;display:flex;justify-content:space-between">
              <div class="meta">Delivery</div>
              <div id="summaryDelivery" class="meta">₹50</div>
            </div>
            <div style="margin-top:12px;display:flex;justify-content:space-between;font-weight:800">
              <div>Total</div>
              <div id="summaryTotal">₹0</div>
            </div>
            <div style="margin-top:8px;font-size:12px;color:var(--muted)">Orders stored in localStorage for demo only.</div>
          </aside>
        </div>
      </div>
    </div>

    <!-- ADMIN / EDIT PRODUCT MODAL -->
    <div id="adminModal" class="modal" aria-hidden="true">
      <div class="sheet" role="dialog" aria-modal="true" aria-label="Catalog admin">
        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:12px">
          <h3 style="margin:0">Catalog Admin</h3>
          <div>
            <button class="btn ghost" id="closeAdmin">Close</button>
          </div>
        </div>

        <div style="display:flex;gap:12px;flex-wrap:wrap;align-items:center;margin-bottom:12px">
          <button class="btn" id="openAddProduct">Add product</button>
          <button class="btn ghost" id="resetCatalog">Reset demo catalog</button>
          <button class="btn ghost" id="downloadProducts">Download catalog JSON</button>
        </div>

        <div id="adminList" style="max-height:360px;overflow:auto"></div>
      </div>
    </div>

    <!-- ADD / EDIT PRODUCT SHEET (small modal) -->
    <div id="productEditModal" class="modal" aria-hidden="true">
      <div class="sheet" style="max-width:520px">
        <h3 id="productEditTitle">Edit product</h3>
        <form id="productForm">
          <input type="hidden" id="prodId" />
          <div style="margin-bottom:8px"><label class="meta">Name</label><input id="prodName" required style="width:100%;padding:8px;border-radius:8px;border:1px solid #e6eef2"/></div>
          <div style="margin-bottom:8px"><label class="meta">Brand</label><input id="prodBrand" style="width:100%;padding:8px;border-radius:8px;border:1px solid #e6eef2"/></div>
          <div style="display:flex;gap:8px;margin-bottom:8px">
            <div style="flex:1"><label class="meta">Price</label><input id="prodPrice" type="number" required style="width:100%;padding:8px;border-radius:8px;border:1px solid #e6eef2"/></div>
            <div style="flex:1"><label class="meta">Stock</label><input id="prodStock" type="number" required style="width:100%;padding:8px;border-radius:8px;border:1px solid #e6eef2"/></div>
          </div>
          <div style="margin-bottom:8px"><label class="meta">Category</label><input id="prodCategory" style="width:100%;padding:8px;border-radius:8px;border:1px solid #e6eef2"/></div>
          <div style="margin-bottom:8px"><label class="meta"><input id="prodRx" type="checkbox" /> Prescription required</label></div>
          <div style="margin-bottom:8px"><label class="meta">Description</label><textarea id="prodDesc" style="width:100%;padding:8px;border-radius:8px;border:1px solid #e6eef2" rows="3"></textarea></div>

          <div style="display:flex;gap:8px">
            <button class="btn" id="saveProduct">Save</button>
            <button class="btn ghost" id="cancelProduct">Cancel</button>
            <button class="btn ghost danger" id="deleteProduct" style="margin-left:auto;background:transparent;color:var(--danger);border:1px solid rgba(220,38,38,0.08)">Delete</button>
          </div>
        </form>
      </div>
    </div>

    <!-- ORDERS & DEBUG -->
    <div class="footer">
      <div class="box">
        <h4 style="margin:0 0 8px 0">Orders (client-side)</h4>
        <div id="ordersList" class="small">No orders yet</div>
      </div>

      <div class="box">
        <h4 style="margin:0 0 8px 0">Export / Debug</h4>
        <div style="display:flex;flex-direction:column;gap:8px">
          <button class="btn ghost" id="exportOrders">Export Orders</button>
          <button class="btn ghost" id="clearOrders">Clear Orders</button>
          <div class="small">LocalStorage keys: <code>medi_products</code>, <code>medi_cart</code>, <code>medi_orders</code></div>
        </div>
      </div>
    </div>
  </div>

  <!-- ========================= SCRIPT ========================= -->
  <script>
    /***********************
      Data & initial demo
    ***********************/
    const DEMO_PRODUCTS = [
      { id: 'm1', name: 'Paracetamol 500mg', brand: 'Acme Pharma', price: 49, category: 'Analgesic', stock: 120, rx: false, expiry:'2026-03-01', desc: 'Relieves pain & reduces fever.' },
      { id: 'm2', name: 'Amoxicillin 500mg', brand: 'HealWell', price: 159, category: 'Antibiotic', stock: 40, rx: true, expiry:'2025-11-12', desc: 'Antibiotic for bacterial infections.' },
      { id: 'm3', name: 'Cetirizine 10mg', brand: 'AllerFix', price: 89, category: 'Antihistamine', stock: 200, rx: false, expiry:'2027-07-21', desc: 'For allergy relief.' },
      { id: 'm4', name: 'Salbutamol Inhaler', brand: 'AirCare', price: 499, category: 'Respiratory', stock: 15, rx: true, expiry:'2026-01-05', desc: 'Relieves bronchospasm.' },
      { id: 'm5', name: 'Ibuprofen 200mg', brand: 'PainAway', price: 59, category: 'Analgesic', stock: 90, rx: false, expiry:'2025-09-30', desc: 'Anti-inflammatory and pain relief.' },
      { id: 'm6', name: 'Multivitamin Syrup', brand: 'NutriPlus', price: 199, category: 'Supplements', stock: 60, rx: false, expiry:'2026-12-31', desc: 'Daily multivitamin for children.' },
      { id: 'm7', name: 'Metformin 500mg', brand: 'GlucoCare', price: 129, category: 'Antidiabetic', stock: 50, rx: true, expiry:'2026-05-20', desc: 'For blood sugar control.' },
      { id: 'm8', name: 'Loperamide 2mg', brand: 'DiarrSol', price: 69, category: 'GI', stock: 180, rx: false, expiry:'2027-02-15', desc: 'Helps relieve diarrhea.' },
      { id: 'm9', name: 'Omeprazole 20mg', brand: 'GastroFix', price: 139, category: 'GI', stock: 100, rx: false, expiry:'2025-10-10', desc: 'For acid reflux and ulcers.' },
      { id: 'm10', name: 'Hydrocortisone Cream 1%', brand: 'SkinCare', price: 149, category: 'Topical', stock: 70, rx: false, expiry:'2026-08-18', desc: 'For mild skin inflammation.' }
    ];

    // Colors for badges
    const BADGE_COLORS = ['#1f7a8c','#0b6b52','#7c3aed','#f97316','#ef4444','#0ea5a4','#059669','#0ea5ff','#6d28d9','#f59e0b'];

    // Load products from localStorage or seed with DEMO_PRODUCTS
    function loadProducts(){
      try{
        const raw = localStorage.getItem('medi_products');
        if(!raw) { localStorage.setItem('medi_products', JSON.stringify(DEMO_PRODUCTS)); return JSON.parse(JSON.stringify(DEMO_PRODUCTS)); }
        return JSON.parse(raw);
      } catch(e){
        console.error('Failed to load products, using demo', e);
        localStorage.setItem('medi_products', JSON.stringify(DEMO_PRODUCTS));
        return JSON.parse(JSON.stringify(DEMO_PRODUCTS));
      }
    }

    let PRODUCTS = loadProducts();

    // App state
    const state = {
      filters: { category: null, min: null, max: null, rx: null },
      search: '',
      sort: 'relevance',
      perPage: Number(document.querySelector('#perPage').value || 6),
      page: 1,
      cart: JSON.parse(localStorage.getItem('medi_cart') || '[]'),
      orders: JSON.parse(localStorage.getItem('medi_orders') || '[]')
    };

    // DOM refs
    const q = s => document.querySelector(s);
    const qa = s => Array.from(document.querySelectorAll(s));
    const productsList = q('#productsList');
    const resultsCount = q('#resultsCount');
    const categoryFiltersBox = q('#categoryFilters');
    const cartList = q('#cartList');
    const ordersList = q('#ordersList');
    const adminList = q('#adminList');
    const pageInfo = q('#pageInfo');

    /* ===================== Utilities ===================== */
    function formatINR(n){ return '₹' + Number(n).toLocaleString('en-IN'); }
    function uid(prefix='id'){ return prefix + Math.random().toString(36).slice(2,9); }
    function persistProducts(){ localStorage.setItem('medi_products', JSON.stringify(PRODUCTS)); }
    function persistCart(){ localStorage.setItem('medi_cart', JSON.stringify(state.cart)); }
    function persistOrders(){ localStorage.setItem('medi_orders', JSON.stringify(state.orders)); }

    function escapeHtml(s){ if(s===null||s===undefined) return ''; return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;'); }

    /* ===================== Rendering ===================== */
    function buildCategoryChips(){
      const cats = [...new Set(PRODUCTS.map(p=>p.category))].sort();
      categoryFiltersBox.innerHTML = '';
      const all = document.createElement('div');
      all.className = 'chip' + (!state.filters.category ? ' active' : '');
      all.textContent = 'All';
      all.onclick = ()=>{ state.filters.category = null; state.page = 1; render(); };
      categoryFiltersBox.appendChild(all);
      cats.forEach(c=>{
        const el = document.createElement('div');
        el.className = 'chip' + (state.filters.category===c ? ' active' : '');
        el.textContent = c;
        el.onclick = ()=>{ state.filters.category = (state.filters.category===c? null : c); state.page = 1; render(); };
        categoryFiltersBox.appendChild(el);
      });
    }

    function applySort(list){
      if(state.sort==='price-asc') return list.sort((a,b)=>a.price-b.price);
      if(state.sort==='price-desc') return list.sort((a,b)=>b.price-a.price);
      if(state.sort==='expiry') return list.sort((a,b)=> new Date(a.expiry) - new Date(b.expiry));
      return list;
    }

    function filteredProducts(){
      return PRODUCTS.filter(p=>{
        if(state.filters.category && p.category !== state.filters.category) return false;
        if(state.filters.rx && !p.rx) return false;
        if(state.filters.min && p.price < state.filters.min) return false;
        if(state.filters.max && p.price > state.filters.max) return false;
        if(state.search){
          const s = state.search.toLowerCase();
          const hay = (p.name + ' ' + p.brand + ' ' + p.category + ' ' + p.desc).toLowerCase();
          if(!hay.includes(s)) return false;
        }
        return true;
      });
    }

    function renderProducts(){
      let list = filteredProducts();
      list = applySort(list);
      resultsCount.textContent = `Showing ${list.length} medicines`;

      // pagination
      const perPage = Number(q('#perPage').value || state.perPage) || 6;
      state.perPage = perPage;
      const totalPages = Math.max(1, Math.ceil(list.length / perPage));
      if(state.page > totalPages) state.page = totalPages;
      const start = (state.page - 1) * perPage;
      const pageSlice = list.slice(start, start + perPage);

      productsList.innerHTML = '';
      pageSlice.forEach((p, idx)=>{
        const card = document.createElement('article');
        card.className = 'card';
        const color = BADGE_COLORS[(PRODUCTS.indexOf(p)) % BADGE_COLORS.length];
        card.innerHTML = `
          <div class="badge" style="background:${color}">${escapeHtml(p.name[0] || '?')}</div>
          <div>
            <h4>${escapeHtml(p.name)} ${p.rx?'<span class="rx">Rx</span>':''}</h4>
            <div class="meta">${escapeHtml(p.brand)} • ${escapeHtml(p.category)}</div>
            <div class="price">${formatINR(p.price)} <span class="meta" style="font-weight:600;margin-left:8px">${p.stock} in stock</span></div>
            <div class="meta" style="margin-top:8px">${escapeHtml(p.desc)}</div>
          </div>
          <div class="actions">
            <button class="btn" data-add="${p.id}">Add</button>
            <button class="btn ghost" data-quick="${p.id}">Quick</button>
            <button class="btn ghost" data-edit="${p.id}">Edit</button>
          </div>
        `;
        productsList.appendChild(card);
      });

      // attach handlers
      qa('[data-add]').forEach(b=>b.onclick = ()=>{ addToCart(b.getAttribute('data-add')); });
      qa('[data-quick]').forEach(b=>b.onclick = ()=>{ quickView(b.getAttribute('data-quick')); });
      qa('[data-edit]').forEach(b=>b.onclick = ()=>{ openEditProduct(b.getAttribute('data-edit')); });

      // pagination controls info
      q('#pageInfo').textContent = `Page ${state.page} of ${totalPages}`;
    }

    function renderCart(){
      if(!state.cart.length){
        cartList.innerHTML = '<div class="meta small">Cart is empty</div>'; q('#orderSummary').textContent = 'No items'; q('#summarySubtotal').textContent = formatINR(0); q('#summaryTotal').textContent = formatINR(0); return;
      }
      cartList.innerHTML = '';
      let subtotal = 0;
      state.cart.forEach(item=>{
        subtotal += item.price * item.qty;
        const div = document.createElement('div');
        div.className = 'cart-item';
        div.innerHTML = `<div style="flex:1"><strong>${escapeHtml(item.name)}</strong><div class="meta">${item.qty} × ${formatINR(item.price)}</div></div>
                         <div style="display:flex;flex-direction:column;gap:6px">
                           <div style="display:flex;gap:6px"><button class="btn ghost" data-dec="${item.id}">−</button><div class="meta">${item.qty}</div><button class="btn ghost" data-inc="${item.id}">+</button></div>
                           <button class="btn ghost" data-rm="${item.id}">Remove</button>
                         </div>`;
        cartList.appendChild(div);
      });
      // handlers
      qa('[data-inc]').forEach(b=>b.onclick = ()=>{ changeQty(b.getAttribute('data-inc'), 1); });
      qa('[data-dec]').forEach(b=>b.onclick = ()=>{ changeQty(b.getAttribute('data-dec'), -1); });
      qa('[data-rm]').forEach(b=>b.onclick = ()=>{ removeFromCart(b.getAttribute('data-rm')); });

      q('#orderSummary').innerHTML = state.cart.map(it=>`<div style="display:flex;justify-content:space-between;padding:6px 0"><div>${escapeHtml(it.name)} × ${it.qty}</div><div>${formatINR(it.price*it.qty)}</div></div>`).join('');
      q('#summarySubtotal').textContent = formatINR(subtotal);
      const delivery = subtotal > 499 ? 0 : 50;
      q('#summaryDelivery').textContent = formatINR(delivery);
      q('#summaryTotal').textContent = formatINR(subtotal + delivery);
    }

    function renderOrders(){
      if(!state.orders.length){
        ordersList.innerHTML = '<div class="meta small">No orders yet</div>'; return;
      }
      ordersList.innerHTML = state.orders.slice(0,12).map(o=>`<div style="padding:8px 0;border-bottom:1px dashed #eef3f6"><strong>${escapeHtml(o.id)}</strong> <div class="meta">${new Date(o.date).toLocaleString()}</div><div class="meta">${o.items.length} items • ${escapeHtml(o.customer.name || '—')}</div><div style="text-align:right;font-weight:700">${formatINR(o.total)}</div></div>`).join('');
    }

    /* ===================== Cart operations ===================== */
    function addToCart(id){
      const p = PRODUCTS.find(x=>x.id===id);
      if(!p) return alert('Product not found');
      const ex = state.cart.find(i=>i.id===id);
      if(ex){
        if(ex.qty < p.stock) ex.qty++;
      } else {
        state.cart.push({ id: p.id, name: p.name, price: p.price, qty: 1, rx: p.rx });
      }
      persistCart(); renderCart();
    }

    function changeQty(id, delta){
      const it = state.cart.find(i=>i.id===id);
      if(!it) return;
      it.qty += delta;
      if(it.qty <= 0) state.cart = state.cart.filter(i=>i.id!==id);
      persistCart(); renderCart();
    }

    function removeFromCart(id){
      state.cart = state.cart.filter(i=>i.id!==id);
      persistCart(); renderCart();
    }

    /* ===================== Quick view ===================== */
    function quickView(id){
      const p = PRODUCTS.find(x=>x.id===id);
      if(!p) return;
      alert(`${p.name}\n\n${p.desc}\n\nBrand: ${p.brand}\nPrice: ${formatINR(p.price)}\nRx Required: ${p.rx ? 'Yes' : 'No'}\nExpiry: ${p.expiry}`);
    }

    /* ===================== Checkout / Orders ===================== */
    q('#checkoutForm').addEventListener('submit', function(e){
      e.preventDefault();
      if(!state.cart.length) return alert('Cart is empty');
      const name = q('#custName').value.trim();
      const phone = q('#custPhone').value.trim();
      const address = q('#custAddress').value.trim();
      if(!name || !phone || !address) return alert('Please fill required fields');
      const subtotal = state.cart.reduce((s,i)=>s + i.price * i.qty, 0);
      const delivery = subtotal > 499 ? 0 : 50;
      const order = {
        id: 'ORD' + Date.now(),
        date: new Date().toISOString(),
        items: state.cart.map(i=>({ id: i.id, name: i.name, qty: i.qty, price: i.price })),
        subtotal, delivery, total: subtotal + delivery,
        customer: { name, phone, address },
        payment: 'demo'
      };
      state.orders.unshift(order);
      persistOrders();
      state.cart = []; persistCart(); renderCart(); renderOrders();
      closeModal('#checkoutModal');
      alert('Order placed (demo). Order id: ' + order.id);
      q('#checkoutForm').reset();
    });

    q('#saveDraft').addEventListener('click', ()=>{ persistCart(); alert('Cart saved locally'); });

    /* ===================== Admin / Product edit ===================== */
    function openAdmin(){
      openModal('#adminModal');
      renderAdminList();
    }

    function renderAdminList(){
      adminList.innerHTML = PRODUCTS.map(p=>{
        return `<div style="display:flex;gap:8px;align-items:center;padding:8px;border-bottom:1px solid #f1f5f9">
          <div style="width:56px;height:56px;border-radius:8px;background:${BADGE_COLORS[PRODUCTS.indexOf(p)%BADGE_COLORS.length]};display:flex;align-items:center;justify-content:center;color:white;font-weight:800">${escapeHtml(p.name[0]||'?')}</div>
          <div style="flex:1">
            <div style="display:flex;justify-content:space-between;align-items:center">
              <div><strong>${escapeHtml(p.name)}</strong><div class="meta">${escapeHtml(p.brand)} • ${escapeHtml(p.category)}</div></div>
              <div style="text-align:right">
                <div class="meta">${formatINR(p.price)}</div>
                <div class="meta">${p.stock} in stock</div>
              </div>
            </div>
          </div>
          <div style="display:flex;flex-direction:column;gap:6px">
            <button class="btn ghost" data-edit="${p.id}">Edit</button>
            <button class="btn ghost" data-delete="${p.id}" style="color:var(--danger)">Delete</button>
          </div>
        </div>`;
      }).join('');
      // attach handlers
      qa('#adminList [data-edit]').forEach(b=>b.onclick = ()=>openEditProduct(b.getAttribute('data-edit')));
      qa('#adminList [data-delete]').forEach(b=>b.onclick = ()=>{ if(confirm('Delete product?')){ deleteProduct(b.getAttribute('data-delete')); } });
    }

    function openEditProduct(id){
      const p = PRODUCTS.find(x=>x.id===id);
      if(!p) return alert('Product not found');
      openModal('#productEditModal');
      q('#productEditTitle').textContent = 'Edit product';
      q('#prodId').value = p.id;
      q('#prodName').value = p.name;
      q('#prodBrand').value = p.brand;
      q('#prodPrice').value = p.price;
      q('#prodStock').value = p.stock;
      q('#prodCategory').value = p.category;
      q('#prodRx').checked = !!p.rx;
      q('#prodDesc').value = p.desc || '';
      q('#deleteProduct').style.display = 'inline-block';
    }

    q('#openAddProduct').addEventListener('click', function(){
      openModal('#productEditModal');
      q('#productEditTitle').textContent = 'Add product';
      q('#prodId').value = '';
      q('#prodName').value = '';
      q('#prodBrand').value = '';
      q('#prodPrice').value = '';
      q('#prodStock').value = '';
      q('#prodCategory').value = '';
      q('#prodRx').checked = false;
      q('#prodDesc').value = '';
      q('#deleteProduct').style.display = 'none';
    });

    q('#saveProduct').addEventListener('click', function(ev){
      ev.preventDefault();
      const id = q('#prodId').value || uid('p');
      const prod = {
        id,
        name: q('#prodName').value.trim() || 'Untitled',
        brand: q('#prodBrand').value.trim() || '',
        price: Number(q('#prodPrice').value || 0),
        stock: Number(q('#prodStock').value || 0),
        category: q('#prodCategory').value.trim() || 'General',
        rx: !!q('#prodRx').checked,
        desc: q('#prodDesc').value.trim() || ''
      };
      const existingIndex = PRODUCTS.findIndex(x=>x.id===id);
      if(existingIndex >= 0) PRODUCTS[existingIndex] = prod;
      else PRODUCTS.unshift(prod);
      persistProducts();
      closeModal('#productEditModal');
      render(); renderAdminList();
    });

    q('#cancelProduct').addEventListener('click', function(ev){ ev.preventDefault(); closeModal('#productEditModal'); });

    q('#deleteProduct').addEventListener('click', function(ev){
      ev.preventDefault();
      const id = q('#prodId').value;
      if(!id) return;
      if(!confirm('Delete this product?')) return;
      deleteProduct(id);
      closeModal('#productEditModal');
      renderAdminList(); render();
    });

    function deleteProduct(id){
      PRODUCTS = PRODUCTS.filter(p=>p.id !== id);
      persistProducts();
      render();
    }

    q('#resetCatalog').addEventListener('click', function(){ if(confirm('Reset demo catalog? This will overwrite local edits.')){ PRODUCTS = JSON.parse(JSON.stringify(DEMO_PRODUCTS)); persistProducts(); render(); renderAdminList(); } });

    q('#downloadProducts').addEventListener('click', function(){
      const data = JSON.stringify(PRODUCTS, null, 2);
      const blob = new Blob([data], { type: 'application/json' });
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a'); a.href = url; a.download = 'medi_products_'+(new Date().toISOString().slice(0,10))+'.json'; a.click(); URL.revokeObjectURL(url);
    });

    q('#importCatalog').addEventListener('change', function(e){
      const f = e.target.files[0];
      if(!f) return;
      const reader = new FileReader();
      reader.onload = function(){ try{ const data = JSON.parse(reader.result); if(Array.isArray(data)){ PRODUCTS = data; persistProducts(); render(); alert('Imported '+data.length+' products'); } else alert('Invalid catalog format (expect JSON array)'); }catch(err){ alert('Failed to import: '+err.message); } };
      reader.readAsText(f);
    });

    /* ===================== Product modal helpers ===================== */
    function openModal(sel){ const m = q(sel); if(!m) return; m.classList.add('open'); m.setAttribute('aria-hidden','false'); }
    function closeModal(sel){ const m = q(sel); if(!m) return; m.classList.remove('open'); m.setAttribute('aria-hidden','true'); }

    q('#openAdmin').addEventListener('click', openAdmin);
    q('#closeAdmin').addEventListener('click', ()=>closeModal('#adminModal'));
    q('#openCheckout').addEventListener('click', ()=>openModal('#checkoutModal'));
    q('#closeCheckout').addEventListener('click', ()=>closeModal('#checkoutModal'));

    /* ===================== Pagination controls ===================== */
    q('#perPage').addEventListener('change', function(){ state.perPage = Number(this.value); state.page = 1; render(); });
    q('#topSort').addEventListener('change', function(){ state.sort = this.value; render(); q('#sidebarSort').value = this.value; });
    q('#sidebarSort').addEventListener('change', function(){ state.sort = this.value; render(); q('#topSort').value = this.value; });

    q('#prevPage').addEventListener('click', function(){ if(state.page>1){ state.page--; render(); } });
    q('#nextPage').addEventListener('click', function(){
      const list = filteredProducts(); const per = Number(q('#perPage').value||state.perPage); const total = Math.max(1, Math.ceil(list.length / per)); if(state.page < total){ state.page++; render(); }
    });
    q('#loadMore').addEventListener('click', function(){
      // load more appends next page's products to current list (simple approach)
      const list = filteredProducts(); const per = Number(q('#perPage').value||state.perPage);
      const nextStart = state.page * per;
      const slice = list.slice(nextStart, nextStart + per);
      if(!slice.length) return alert('No more products');
      // append cards for slice
      slice.forEach(p=>{
        const card = document.createElement('article'); card.className='card';
        const color = BADGE_COLORS[(PRODUCTS.indexOf(p)) % BADGE_COLORS.length];
        card.innerHTML = `<div class="badge" style="background:${color}">${escapeHtml(p.name[0]||'?')}</div>
          <div><h4>${escapeHtml(p.name)} ${p.rx?'<span class="rx">Rx</span>':''}</h4><div class="meta">${escapeHtml(p.brand)} • ${escapeHtml(p.category)}</div><div class="price">${formatINR(p.price)} <span class="meta" style="font-weight:600;margin-left:8px">${p.stock} in stock</span></div><div class="meta" style="margin-top:8px">${escapeHtml(p.desc)}</div></div>
          <div class="actions"><button class="btn" data-add="${p.id}">Add</button><button class="btn ghost" data-quick="${p.id}">Quick</button><button class="btn ghost" data-edit="${p.id}">Edit</button></div>`;
        productsList.appendChild(card);
      });
      // attach newly added handlers
      qa('[data-add]').forEach(b=>b.onclick = ()=>addToCart(b.getAttribute('data-add')));
      qa('[data-quick]').forEach(b=>b.onclick = ()=>quickView(b.getAttribute('data-quick')));
      qa('[data-edit]').forEach(b=>b.onclick = ()=>openEditProduct(b.getAttribute('data-edit')));
      state.page++;
      // update pageInfo (approx)
      const totalPages = Math.max(1, Math.ceil(filteredProducts().length / per));
      q('#pageInfo').textContent = `Page ${Math.min(state.page, totalPages)} of ${totalPages}`;
    });

    /* ===================== Orders export/clear ===================== */
    q('#exportOrders').addEventListener('click', function(){
      if(!state.orders.length) return alert('No orders');
      const data = JSON.stringify(state.orders, null, 2);
      const blob = new Blob([data], { type: 'application/json' });
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a'); a.href = url; a.download = 'medi_orders_'+(new Date().toISOString().slice(0,10))+'.json'; a.click(); URL.revokeObjectURL(url);
    });

    q('#clearOrders').addEventListener('click', function(){ if(confirm('Clear all local orders?')){ state.orders=[]; persistOrders(); renderOrders(); } });

    /* ===================== Export / Import catalog ===================== */
    q('#exportCatalog').addEventListener('click', function(){
      const data = JSON.stringify(PRODUCTS, null, 2);
      const blob = new Blob([data], { type: 'application/json' });
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a'); a.href = url; a.download = 'medi_products_'+(new Date().toISOString().slice(0,10))+'.json'; a.click(); URL.revokeObjectURL(url);
    });

    /* ===================== Catalog CRUD helpers ===================== */
    function deleteProduct(id){
      if(!confirm('Delete product?')) return;
      PRODUCTS = PRODUCTS.filter(p=>p.id !== id);
      persistProducts(); render(); renderAdminList();
    }

    /* ===================== Search & filters handlers ===================== */
    q('#searchInput').addEventListener('input', function(){ state.search = this.value.trim().toLowerCase(); state.page = 1; render(); });
    q('#applyPrice').addEventListener('click', function(){ state.filters.min = q('#minPrice').value ? Number(q('#minPrice').value) : null; state.filters.max = q('#maxPrice').value ? Number(q('#maxPrice').value) : null; state.page = 1; render(); });
    q('#clearAll').addEventListener('click', function(){ state.filters = { category:null, min:null, max:null, rx:null }; q('#minPrice').value = ''; q('#maxPrice').value = ''; q('#searchInput').value=''; state.search=''; state.page = 1; render(); });

    q('#prescFilterToggle').addEventListener('click', function(){
      state.filters.rx = state.filters.rx ? null : true; q('#prescFilterToggle').textContent = state.filters.rx ? 'RX: Required' : 'RX: All'; state.page = 1; render();
    });

    /* ===================== Modal close helpers (click outside to close) ===================== */
    qa('.modal').forEach(mod=>{
      mod.addEventListener('click', function(e){ if(e.target === mod){ closeModal('#' + mod.id); } });
    });

    /* ===================== Initialization ===================== */
    function render(){
      buildCategoryChips(); renderProducts(); renderCart(); renderOrders();
    }

    // initial render
    render();

    // expose some functions for debugging in console
    window.MediStreet = { PRODUCTS, state, render, persistProducts };

    console.log('MediStreet ready — JSP EL disabled (isELIgnored=true). Local keys: medi_products, medi_cart, medi_orders');
  </script>
</body>
</html>

