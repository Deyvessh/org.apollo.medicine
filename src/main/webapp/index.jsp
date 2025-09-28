<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1"/>
  <title>MediStreet — Demo Pharmacy</title>

  <style>
    :root {
      --bg:#f6f8fb; --card:#fff; --muted:#6b7280;
      --accent:#1f7a8c; --accent-2:#0b6b52;
      --shadow:0 6px 20px rgba(15,23,42,0.08);
      font-family: Inter, system-ui, Arial, sans-serif;
    }
    body {margin:0;background:var(--bg);color:#0f172a;line-height:1.45}
    header {
      background:var(--card);box-shadow:var(--shadow);padding:12px 20px;
      display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:12px;
      position:sticky;top:0;z-index:10;
    }
    .brand{display:flex;align-items:center;gap:12px}
    .logo{width:48px;height:48px;border-radius:10px;background:linear-gradient(135deg,var(--accent),var(--accent-2));display:flex;align-items:center;justify-content:center;color:white;font-weight:800;font-size:18px}
    .controls{display:flex;align-items:center;gap:12px;flex-wrap:wrap}
    .search{background:#f8fafc;border-radius:10px;padding:8px 10px;display:flex;align-items:center;gap:8px;border:1px solid #e6eef2}
    .search input{border:0;background:transparent;outline:0;width:200px}
    .pill{padding:6px 10px;border-radius:999px;background:#e6fffa;color:var(--accent-2);font-weight:700;cursor:pointer}
    .cart-mini{background:var(--card);padding:10px;border-radius:10px;box-shadow:var(--shadow);min-width:200px}
    .app{display:grid;grid-template-columns:260px 1fr;gap:20px;max-width:1200px;margin:20px auto}
    aside{background:var(--card);padding:16px;border-radius:12px;box-shadow:var(--shadow);align-self:start}
    .products{display:grid;grid-template-columns:repeat(auto-fill,minmax(220px,1fr));gap:16px}
    .card{background:var(--card);padding:12px;border-radius:12px;box-shadow:var(--shadow);display:flex;flex-direction:column;gap:8px}
    .badge{width:100%;height:100px;border-radius:8px;display:flex;align-items:center;justify-content:center;font-size:48px;font-weight:700;color:white}
    .card h4{margin:0;font-size:15px}
    .meta{font-size:13px;color:var(--muted)}
    .price{font-weight:800}
    .rx{font-size:11px;padding:4px 8px;border-radius:999px;background:#fff4e6;color:#92400e;border:1px solid #ffe2b4;margin-left:6px}
    .actions{display:flex;gap:8px;margin-top:auto}
    .btn{padding:6px 10px;border-radius:8px;border:0;cursor:pointer;background:var(--accent);color:white;font-weight:600}
    .btn.ghost{background:#f0fdfd;color:var(--accent)}
    .cart-list{max-height:200px;overflow:auto;margin-top:8px;font-size:13px}
    .modal{position:fixed;inset:0;display:none;align-items:center;justify-content:center;background:rgba(0,0,0,0.4);z-index:50}
    .modal.open{display:flex}
    .sheet{width:600px;max-width:95%;background:var(--card);padding:16px;border-radius:12px;box-shadow:var(--shadow)}
    .footer-section{max-width:1200px;margin:20px auto;display:grid;grid-template-columns:2fr 1fr;gap:20px}
    .box{background:var(--card);padding:12px;border-radius:12px;box-shadow:var(--shadow)}
    .small{font-size:13px;color:var(--muted)}
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
        <div class="small">Trusted demo pharmacy • client-side demo</div>
      </div>
    </div>
    <div class="controls">
      <div class="search"><input id="searchInput" placeholder="Search medicines"/></div>
      <div class="pill" id="prescFilterToggle">RX: All</div>
      <div class="cart-mini">
        <div style="display:flex;justify-content:space-between"><strong>Cart</strong><button id="openCheckout">Checkout →</button></div>
        <div id="cartList" class="cart-list">Cart is empty</div>
      </div>
    </div>
  </header>

  <!-- MAIN APP GRID -->
  <div class="app">
    <aside>
      <h3>Filters</h3>
      <div><strong>Categories</strong><div id="categoryFilters"></div></div>
      <div style="margin-top:10px"><strong>Price</strong><br/>Min <input id="minPrice" type="number" style="width:60px"/> Max <input id="maxPrice" type="number" style="width:60px"/><button id="applyPrice">Apply</button></div>
      <div style="margin-top:10px"><strong>Sort</strong><br/><select id="sidebarSort"><option value="relevance">Relevance</option><option value="price-asc">Price ↑</option><option value="price-desc">Price ↓</option></select></div>
      <button id="clearAll" style="margin-top:10px">Clear Filters</button>
    </aside>

    <main>
      <div id="resultsCount">Showing medicines</div>
      <section class="products" id="productsList"></section>
      <div id="noResults" style="display:none">No medicines found</div>
    </main>
  </div>

  <!-- CHECKOUT MODAL -->
  <div id="checkoutModal" class="modal">
    <div class="sheet">
      <h3>Checkout</h3>
      <form id="checkoutForm">
        <input id="custName" placeholder="Full name" required style="width:100%;margin:4px 0"/>
        <input id="custPhone" placeholder="Phone" required style="width:100%;margin:4px 0"/>
        <textarea id="custAddress" placeholder="Address" required style="width:100%;margin:4px 0"></textarea>
        <select id="paymentMethod" style="width:100%;margin:4px 0"><option value="cod">Cash on delivery</option><option value="card">Card</option></select>
        <button type="submit" class="btn">Place Order</button>
        <button type="button" id="closeCheckout" class="btn ghost">Cancel</button>
      </form>
      <div id="orderSummary" style="margin-top:10px;font-size:14px"></div>
    </div>
  </div>

  <!-- ORDERS & DEBUG -->
  <div class="footer-section">
    <div class="box">
      <h4>Your orders</h4>
      <div id="ordersList" class="small">No orders yet</div>
    </div>
    <div class="box">
      <h4>Debug</h4>
      <button id="exportOrders">Export Orders</button>
      <button id="clearOrders">Clear Orders</button>
    </div>
  </div>

  <script>
    const COLORS=["#1f7a8c","#0b6b52","#7c3aed","#f97316","#ef4444","#0ea5a4","#059669","#0ea5ff","#7c3aed","#f59e0b"];
    const MEDICINES=[
      {id:"m1",name:"Paracetamol 500mg",brand:"Acme Pharma",price:49,category:"Analgesic",stock:120,rx:false,desc:"Relieves pain & reduces fever."},
      {id:"m2",name:"Amoxicillin 500mg",brand:"HealWell",price:159,category:"Antibiotic",stock:40,rx:true,desc:"Antibiotic for bacterial infections."},
      {id:"m3",name:"Cetirizine 10mg",brand:"AllerFix",price:89,category:"Antihistamine",stock:200,rx:false,desc:"For allergy relief."},
      {id:"m4",name:"Salbutamol Inhaler",brand:"AirCare",price:499,category:"Respiratory",stock:15,rx:true,desc:"Relieves bronchospasm."},
      {id:"m5",name:"Ibuprofen 200mg",brand:"PainAway",price:59,category:"Analgesic",stock:90,rx:false,desc:"Anti-inflammatory and pain relief."},
      {id:"m6",name:"Multivitamin Syrup",brand:"NutriPlus",price:199,category:"Supplements",stock:60,rx:false,desc:"Daily multivitamin for children."},
      {id:"m7",name:"Metformin 500mg",brand:"GlucoCare",price:129,category:"Antidiabetic",stock:50,rx:true,desc:"For blood sugar control."},
      {id:"m8",name:"Loperamide 2mg",brand:"DiarrSol",price:69,category:"GI",stock:180,rx:false,desc:"Helps relieve diarrhea."},
      {id:"m9",name:"Omeprazole 20mg",brand:"GastroFix",price:139,category:"GI",stock:100,rx:false,desc:"For acid reflux and ulcers."},
      {id:"m10",name:"Hydrocortisone Cream 1%",brand:"SkinCare",price:149,category:"Topical",stock:70,rx:false,desc:"For mild skin inflammation."}
    ];
    let state={cart:JSON.parse(localStorage.getItem("medi_cart")||"[]"),orders:JSON.parse(localStorage.getItem("medi_orders")||"[]"),filters:{category:null,min:null,max:null,rx:null},search:"",sort:"relevance"};
    const productsList=document.querySelector("#productsList"),resultsCount=document.querySelector("#resultsCount"),cartList=document.querySelector("#cartList"),checkoutModal=document.querySelector("#checkoutModal"),ordersList=document.querySelector("#ordersList");
    function renderProducts(){
      let list=MEDICINES.filter(m=>{
        if(state.filters.category&&m.category!==state.filters.category)return false;
        if(state.filters.rx&&!m.rx)return false;
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
      list.forEach((m,i)=>{
        const c=document.createElement("div");c.className="card";
        c.innerHTML=`<div class="badge" style="background:${COLORS[i%COLORS.length]}">${m.name[0]}</div>
          <h4>${m.name}${m.rx?'<span class="rx">Rx</span>':""}</h4>
          <div class="meta">${m.brand} • ${m.category}</div>
          <div class="price">₹${m.price} <span class="small">${m.stock} in stock</span></div>
          <div class="small">${m.desc}</div>
          <div class="actions"><button class="btn" data-add="${m.id}">Add</button><button class="btn ghost" data-view="${m.id}">Quick</button></div>`;
        productsList.appendChild(c);
      });
      document.querySelectorAll("[data-add]").forEach(b=>b.onclick=()=>addToCart(b.dataset.add));
      document.querySelectorAll("[data-view]").forEach(b=>b.onclick=()=>alert(list.find(m=>m.id===b.dataset.view).desc));
      resultsCount.textContent=`Showing ${list.length} medicines`;
    }
    function addToCart(id){const med=MEDICINES.find(m=>m.id===id);if(!med)return;const ex=state.cart.find(i=>i.id===id);if(ex)ex.qty++;else state.cart.push({id:med.id,name:med.name,price:med.price,qty:1});saveCart();renderCart();}
    function saveCart(){localStorage.setItem("medi_cart",JSON.stringify(state.cart));}
    function renderCart(){
      if(!state.cart.length){cartList.textContent="Cart is empty";return;}
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
    function renderOrders(){if(!state.orders.length){ordersList.textContent="No orders yet";return;}ordersList.innerHTML=state.orders.map(o=>`<div><strong>${o.id}</strong> - ₹${o.total} - ${o.customer.name}</div>`).join("");}
    document.querySelector("#exportOrders").onclick=()=>{const data=JSON.stringify(state.orders,null,2);const blob=new Blob([data],{type:"application/json"});const url=URL.createObjectURL(blob);const a=document.createElement("a");a.href=url;a.download="orders.json";a.click();URL.revokeObjectURL(url);}
    document.querySelector("#clearOrders").onclick=()=>{if(confirm("Clear orders?")){state.orders=[];localStorage.setItem("medi_orders","[]");renderOrders();}};
    document.querySelector("#searchInput").oninput=e=>{state.search=e.target.value.toLowerCase();renderProducts();}
    document.querySelector("#sidebarSort").onchange=e=>{state.sort=e.target.value;renderProducts();}
    document.querySelector("#applyPrice").onclick=()=>{state.filters.min=+document.querySelector("#minPrice").value||null;state.filters.max=+document.querySelector("#maxPrice").value||null;renderProducts();}
    document.querySelector("#clearAll").onclick=()=>{state.filters={category:null,min:null,max:null,rx:null};document.querySelector("#minPrice").value=document.querySelector("#maxPrice").value="";document.querySelector("#searchInput").value="";state.search="";renderProducts();}
    document.querySelector("#prescFilterToggle").onclick=()=>{state.filters.rx=state.filters.rx?null:true;document.querySelector("#prescFilterToggle").textContent=state.filters.rx?"RX: Required":"RX: All";renderProducts();}
    function buildCategoryChips(){const cats=[...new Set(MEDICINES.map(m=>m.category))];const box=document.querySelector("#categoryFilters");box.innerHTML="";["All",...cats].forEach(c=>{const el=document.createElement("div");el.textContent=c;el.style.cursor="pointer";el.style.margin="2px";if(state.filters.category===c||(c==="All"&&!state.filters.category))el.style.fontWeight="700";el.onclick=()=>{state.filters.category=c==="All"?null:c;renderProducts();buildCategoryChips();};box.appendChild(el);});}
    buildCategoryChips();renderProducts();renderCart();renderOrders();
  </script>
</body>
</html>

