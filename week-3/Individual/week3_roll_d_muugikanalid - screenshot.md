-- Ühendan `sales` ja `customers` — klientide profiil kanali kaupa: 
-- Millistest linnadest kliendid milliseid kanaleid kasutavad? 

| müügikanal | linn       | kliente | kogumüük  |
| ---------- | ---------- | ------- | --------- |
| online     | Tallinn    | 667     | 335719.11 |
| online     | Tartu      | 345     | 179175.44 |
| online     | Pärnu      | 188     | 135423.94 |
| online     | Narva      | 94      | 42551.86  |
| online     | Viljandi   | 67      | 41489.32  |
| online     | Rakvere    | 55      | 30783.20  |
| online     | Haapsalu   | 58      | 29901.08  |
| online     | Jõhvi      | 56      | 28637.57  |
| online     | Kuressaare | 52      | 25462.83  |
| online     | Valga      | 44      | 23796.96  |
| online     | Võru       | 48      | 20942.35  |
| online     | Paide      | 32      | 14856.47  |
| pood       | Tallinn    | 910     | 670533.77 |
| pood       | Tartu      | 461     | 344111.20 |
| pood       | Pärnu      | 258     | 238581.92 |
| pood       | Narva      | 121     | 79674.28  |
| pood       | Rakvere    | 78      | 62595.83  |
| pood       | Viljandi   | 81      | 60825.62  |
| pood       | Kuressaare | 71      | 51046.78  |
| pood       | Jõhvi      | 62      | 48963.58  |
| pood       | Haapsalu   | 66      | 43591.75  |
| pood       | Võru       | 57      | 40040.72  |
| pood       | Paide      | 50      | 38292.40  |
| pood       | Valga      | 63      | 35733.80  |

--========================================================================================
--Ühendan 3 tabelit: `sales` + `customers` + `products`: 3 tabeli JOIN: millised tooted müüvad millises kanalis? 

| müügikanal | tootekategooria | kliente | oste | kogumüük  | keskmine_ost |
| ---------- | --------------- | ------- | ---- | --------- | ------------ |
| online     | jalanõusid      | 524     | 632  | 248820.61 | 393.70       |
| online     | meeste_riided   | 548     | 686  | 233375.66 | 340.20       |
| online     | naiste_riided   | 534     | 647  | 215503.09 | 333.08       |
| online     | aksessuaarid    | 445     | 536  | 116710.11 | 217.74       |
| online     | laste_riided    | 506     | 627  | 94330.66  | 150.45       |
| pood       | meeste_riided   | 996     | 1362 | 447173.58 | 328.32       |
| pood       | jalanõusid      | 872     | 1184 | 440060.24 | 371.67       |
| pood       | naiste_riided   | 892     | 1193 | 408066.19 | 342.05       |
| pood       | aksessuaarid    | 801     | 1073 | 238250.10 | 222.04       |
| pood       | laste_riided    | 883     | 1190 | 180441.54 | 151.63       |