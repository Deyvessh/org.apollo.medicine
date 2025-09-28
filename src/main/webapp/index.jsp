<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1"/>
  <title>MediStreet — Online Pharmacy Demo</title>

  <style>
    :root {
      --bg:#f6f8fb; --card:#fff; --muted:#6b7280;
      --accent:#1f7a8c; --accent-2:#0b6b52; --danger:#dc2626;
      --shadow:0 4px 12px rgba(15,23,42,0.08);
      font-family: Inter, system-ui, Arial, sans-serif;
    }
    body {margin:0;background:var(--bg);color:#111;line-height:1.5}
    header {
      background:var(--card);box-shadow:var(--shadow);padding:12px 20px;
      display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:12px;
      position:sticky;top:0;z-index:10;
    }
    .brand {display:flex;align-items:center;gap:12px}
    .logo {width:40px;height:40px;border-radius:8px;
      background:linear-gradient(135deg,var(--accent),var(--accent-2));
      display:flex;align-items:center;justify-content:center;color:white;font-weight:700}
    .controls {display:flex;align-items:center;gap:12px;flex-wrap:wrap}
    .search {background:#f9fafb;border:1px solid #e5e7eb;border-radius:8px;padding:6px 10px;display:flex;align-items:center;gap:8px}
    .search input{border:0;background:transparent;outline:0;width:220px}
    .pill {padding:6px 10px;border-radius:999px;background:#e0f2f1;color:var(--accent);font-weight:600;cursor:pointer}
    .cart-mini {background:var(--card);padding:10px;border-radius:8px;box-shadow:var(--shadow);min-width:200px}
    .app {display:grid;grid-template-columns:260px 1fr;gap:20px;max-width:1200px;margin:20px auto}
    aside {background:var(--card);padding:16px;border-radius:8px;box-shadow:var(--shadow);align-self:start}
    main {background:transparent}
    .products {display:grid;grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:16px}
    .card {background:var(--card);padding:12px;border-radius:8px;box-shadow:var(--shadow);display:flex;flex-direction:column;justify-content:space-between}
    .card h4{margin:0 0 6px 0;font-size:15px}
    .price{font-weight:700;margin-top:6px}
    .rx{font-size:12px;color:#92400e;background:#fff3e0;padding:2px 6px;border-radius:6px;margin-left:6px}
    .btn{padding:6px 10px;border-radius:6px;border:0;cursor:pointer;background:var(--accent);color:white;font-weight:600}
    .btn.ghost{background:#f0fdfd;color:var(--accent)}
    .footer-section {max-width:1200px;margin:20px auto;display:grid;grid-template-columns:2fr 1fr;gap:20px}
    .box {background:var(--card);padding:16px;border-radius:8px;box-shadow:var(--shadow)}
    .modal{position:fixed;inset:0;display:none;align-items:center;justify-content:center;background:rgba(0,0,0,0.4);z-index:50}
    .modal.open{display:flex}
    .modal .sheet{width:600px;max-width:95%;background:var(--card);padding:16px;border-radius:8px;box-shadow:var(--shadow)}
    @media(max-width:900px){
      .app{grid-template-columns:1fr}
      .footer-section{grid-template-columns:1fr}
    }
  </style>
</head>
<body>

  <!-- HEADER -->
  <header>
    <div class="brand">
      <div class="logo">MS</div>
      <div>
        <div><strong>MediStreet</strong></div>
        <div style="font-size:13px;color:var(--muted)">Trusted demo pharmacy • client-side demo</div>
      </div>
    </div>
    <div class="controls">
      <div class="search"><input id="searchInput" placeholder="Search medicines, e.g., paracetamol, cough"/></div>
      <div class="pill" id="prescFilterToggle">RX: All</div>
      <div class="cart-mini" id="cartMini">
        <div style="display:flex;justify-content:space-between">
          <strong>Cart</strong> <button id="openCheckout">Checkout →</button>
        </div>
        <div id="cartList" style="font-size:13px;color:var(--muted)">Cart is empty</div>
      </div>
    </div>
  </header>

  <!-- MAIN APP GRID -->
  <div class="app">
    <!-- Sidebar -->
    <aside>
      <h3>Filters</h3>
      <div><strong>Categories</strong><div id="categoryFilters"></div></div>
      <div style="margin-top:10px"><strong>Price range</strong><br/>Min <input id="minPrice" type="number" style="width:60px"/> Max <input id="maxPrice" type="number" style="width:60px"/><button id="applyPrice">Apply</button></div>
      <div style="margin-top:10px"><strong>Sort</strong><br/><select id="sidebarSort"><option value="relevance">Relevance</option><option value="price-asc">Price ↑</option><option value="price-desc">Price ↓</option></select></div>
      <div style="margin-top:10px"><strong>Store info</strong><br/>Open: Mon–Sat 9–20<br/>Delivery: 2–4 days<br/>Address: Demo Lane</div>
      <button id="clearAll" style="margin-top:10px">Clear Filters</button>
    </aside>

    <!-- Products -->
    <main>
      <div style="margin-bottom:10px">
        <div id="resultsCount">Showing medicines</div>
        <small style="color:var(--muted)">Pharmacist advice: demo only</small>
      </div>
      <div class="products" id="productsList"></div>
      <div id="noResults" style="display:none">No medicines found</div>
    </main>
  </div>

  <!-- ORDERS & DEBUG -->
  <div class="footer-section">
    <div class="box">
      <h4>Your recent orders (demo)</h4>
      <div id="ordersList" style="color:var(--muted)">No orders yet</div>
    </div>
    <div class="box">
      <h4>Debug & Export</h4>
      <button id="exportOrders">Export Orders</button>
      <button id="clearOrders">Clear Orders</button>
    </div>
  </div>

  <!-- CHECKOUT MODAL -->
  <div id="checkoutModal" class="modal">
    <div class="sheet">
      <h3>Checkout</h3>
      <form id="checkoutForm">
        <input id="custName" placeholder="Full name" required style="width:100%;margin:4px 0"/>
        <input id="custPhone" placeholder="Phone" required style="width:100%;margin:4px 0"/>
        <textarea id="custAddress" placeholder="Address" required style="width:100%;margin:4px 0"></textarea>
        <select id="paymentMethod" style="width:100%;margin:4px 0">
          <option value="cod">Cash on delivery</option>
          <option value="card">Card (demo)</option>
        </select>
        <button type="submit" class="btn">Place Order</button>
        <button type="button" id="closeCheckout" class="btn ghost">Cancel</button>
      </form>
      <div id="orderSummary" style="margin-top:10px;font-size:14px"></div>
    </div>
  </div>

  <!-- JS -->
  <script>
    // Data
    const MEDICINES=[
      {id:"m1",name:"Paracetamol 500mg",price:49,category:"Analgesic",rx:false},
      {id:"m2",name:"Amoxicillin 500mg",price:159,category:"Antibiotic",rx:true},
      {id:"m3",name:"Cetirizine 10mg",price:89,category:"Antihistamine",rx:false},
      {id:"m4",name:"Salbutamol Inhaler",price:499,category:"Respiratory",rx:true},
      {id:"m5",name:"Ibuprofen 200mg",price:59,category:"Analgesic",rx:false}
    ];
    let state={cart:JSON.parse(localStorage.getItem("medi_cart")||"[]"),orders:JSON.parse(localStorage.getItem("medi_orders")||"[]"),filters:{category:null,min:null,max:null,rx:null},search:"",sort:"relevance"};

    const productsList=document.querySelector("#productsList"),
          cartList=document.querySelector("#cartList"),
          resultsCount=document.querySelector("#resultsCount"),
          checkoutModal=document.querySelector("#checkoutModal"),
          ordersList=document.querySelector("#ordersList");

    function renderProducts(){
      let list=MEDICINES.filter(m=>{
        if(state.filters.category&&m.category!==state.filters.category)return false;
        if(state.filters.rx&& !m.rx)return false;
        if(state.filters.min&&m.price<state.filters.min)return false;
        if(state.filters.max&&m.price>state.filters.max)return false;
        if(state.search&&!m.name.toLowerCase().includes(state.search))return false;
        return true;
      });
      if(state.sort==="price-asc")list.sort((a,b)=>a.price-b.price);
      if(state.sort==="price-desc")list.sort((a,b)=>b.price-a.price);
      productsList.innerHTML="";
      if(!list.length){document.querySelector("#noResults").style.display="block";return;}
      document.querySelector("#noResults").style.display="none";
      list.forEach(m=>{
        const c=document.createElement("div");c.className="card";
        c.innerHTML=`<h4>${m.name}${m.rx?'<span class="rx">Rx</span>':""}</h4><div class="price">₹${m.price}</div><button class="btn" data-add="${m.id}">Add to Cart</button>`;
        productsList.appendChild(c);
      });
      document.querySelectorAll("[data-add]").forEach(b=>b.onclick=()=>addToCart(b.dataset.add));
      resultsCount.textContent=`Showing ${list.length} medicines`;
    }
    function addToCart(id){const med=MEDICINES.find(m=>m.id===id);if(!med)return;const ex=state.cart.find(i=>i.id===id);if(ex)ex.qty++;else state.cart.push({id:med.id,name:med.name,price:med.price,qty:1});saveCart();renderCart();}
    function saveCart(){localStorage.setItem("medi_cart",JSON.stringify(state.cart));}
    function renderCart(){
      if(!state.cart.length){cartList.textContent="Cart is empty";document.querySelector("#orderSummary").textContent="";return;}
      cartList.innerHTML="";let total=0;
      state.cart.forEach(it=>{total+=it.price*it.qty;const r=document.createElement("div");r.innerHTML=`${it.name} x ${it.qty} = ₹${it.price*it.qty} <button data-rm="${it.id}">x</button>`;cartList.appendChild(r);});
      document.querySelectorAll("[data-rm]").forEach(b=>b.onclick=()=>{state.cart=state.cart.filter(i=>i.id!==b.dataset.rm);saveCart();renderCart();});
      document.querySelector("#orderSummary").textContent="Total: ₹"+total;
    }
    document.querySelector("#openCheckout").onclick=()=>checkoutModal.classList.add("open");
    document.querySelector("#closeCheckout").onclick=()=>checkoutModal.classList.remove("open");
    document.querySelector("#checkoutForm").onsubmit=e=>{
      e.preventDefault();if(!state.cart.length)return alert("Cart empty");
      const order={id:"ORD"+Date.now(),date:new Date().toLocaleString(),items:[...state.cart],customer:{name:document.querySelector("#custName").value},total:state.cart.reduce((s,i)=>s+i.price*i.qty,0)};
      state.orders.unshift(order);localStorage.setItem("medi_orders",JSON.stringify(state.orders));
      state.cart=[];saveCart();renderCart();renderOrders();checkoutModal.classList.remove("open");alert("Order placed: "+order.id);
    };
    function renderOrders(){
      if(!state.orders.length){ordersList.textContent="No orders yet";return;}
      ordersList.innerHTML=state.orders.map(o=>`<div><strong>${o.id}</strong> (${o.date}) - ₹${o.total} - ${o.customer.name}</div>`).join("");
    }
    document.querySelector("#exportOrders").onclick=()=>{
      const data=JSON.stringify(state.orders,null,2);
      const blob=new Blob([data],{type:"application/json"}),url=URL.createObjectURL(blob);
      const a=document.createElement("a");a.href=url;a.download="orders.json";a.click();URL.revokeObjectURL(url);
    };
    document.querySelector("#clearOrders").onclick=()=>{if(confirm("Clear orders?")){state.orders=[];localStorage.setItem("medi_orders","[]");renderOrders();}};
    document.querySelector("#searchInput").oninput=e=>{state.search=e.target.value.toLowerCase();renderProducts();}
    document.querySelector("#sidebarSort").onchange=e=>{state.sort=e.target.value;renderProducts();}
    document.querySelector("#applyPrice").onclick=()=>{state.filters.min=+document.querySelector("#minPrice").value||null;state.filters.max=+document.querySelector("#maxPrice").value||null;renderProducts();}
    document.querySelector("#clearAll").onclick=()=>{state.filters={category:null,min:null,max:null,rx:null};document.querySelector("#minPrice").value="";document.querySelector("#maxPrice").value="";document.querySelector("#searchInput").value="";state.search="";renderProducts();}
    document.querySelector("#prescFilterToggle").onclick=()=>{state.filters.rx=state.filters.rx?null:true;document.querySelector("#prescFilterToggle").textContent=state.filters.rx?"RX: Required":"RX: All";renderProducts();}
    function buildCategoryChips(){
      const cats=[...new Set(MEDICINES.map(m=>m.category))];const box=document.querySelector("#categoryFilters");box.innerHTML="";
      const all=document.createElement("div");all.textContent="All";all.style.cursor="pointer";all.onclick=()=>{state.filters.category=null;renderProducts();buildCategoryChips();};box.appendChild(all);
      cats.forEach(c=>{const el=document.createElement("div");el.textContent=c;el.style.cursor="pointer";if(state.filters.category===c)el.style.fontWeight="700";el.onclick=()=>{state.filters.category=c;renderProducts();buildCategoryChips();};box.appendChild(el);});
    }
    buildCategoryChips();renderProducts();renderCart();renderOrders();
  </script>
</body>
</html>

