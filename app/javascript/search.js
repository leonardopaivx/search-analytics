import { debounce } from "debounce";

const input = document.getElementById("search-input");
const resultsEl = document.getElementById("results");

function renderResults(items) {
    resultsEl.innerHTML = "";
    items.forEach((item) => {
        const li = document.createElement("li");
        li.innerHTML = `
      <a href="/articles/${item.id}"
         class="block p-3 rounded-md border border-slate-200 hover:bg-slate-50 hover:border-slate-300 transition">
        <h3 class="font-medium text-slate-800">${item.title}</h3>
      </a>
    `;
        resultsEl.appendChild(li);
    });
}

async function fetchResults(q) {
    if (!q) { renderResults([]); return; }
    const res = await fetch(`/search?q=${encodeURIComponent(q)}`, {
        headers: { "Accept": "application/json" }
    });
    const data = await res.json();
    renderResults(data.results);
}

function logEvent(q, final = false) {
    const payload = JSON.stringify({ query: q, final: final });
    if (navigator.sendBeacon) {
        const blob = new Blob([payload], { type: 'application/json' });
        navigator.sendBeacon('/search_events', blob);
    } else {
        fetch('/search_events', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'X-CSRF-Token': getCSRFToken() },
            body: payload
        });
    }
}

const debouncedFetch = debounce((q) => fetchResults(q), 200);
const debouncedFinal  = debounce((q) => logEvent(q, true), 600);

input.addEventListener('input', (e) => {
    const q = e.target.value;
    logEvent(q, false);
    debouncedFetch(q);
    debouncedFinal(q);
});

function getCSRFToken() {
    return document.querySelector('meta[name="csrf-token"]').getAttribute('content');
}
