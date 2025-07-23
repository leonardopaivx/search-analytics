# Pin npm packages by running ./bin/importmap

pin "application"
pin "search", to: "search.js", preload: true
pin "debounce", to: "utils/debounce.js"

pin "chart.js", to: "https://ga.jspm.io/npm:chart.js@4.2.0/dist/chart.js"
pin "@kurkle/color", to: "https://ga.jspm.io/npm:@kurkle/color@0.3.2/dist/color.esm.js"
