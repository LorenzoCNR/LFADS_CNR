LFADS (Latent Factor Analysis via Dynamical Systems) è un metodo utilizzato per decomporre dati 
di serie temporali in vari fattori, tra cui una condizione iniziale, un sistema dinamico generativo,
input di controllo per quel generatore e una descrizione a bassa dimensionalità dei dati osservati,
chiamata "fattori". 
LFADS utilizza a reti neurali ricorrenti artificiali non lineari per analizzare i dati neurali mirando al supramento delle difficoltà nell'analizzare le dinamiche della popolazione neurale su singole prove, una sfida significativa dovuta alla variabilità tra le prove e alle fluttuazioni nella spiking di singoli neuroni.

LFADS si basa sull'assunto che l'attività di spiking in una singola prova dipende dalle dinamiche sottostanti caratteristiche dell'area cerebrale registrata e la  variabilità di spiking sia di tipo Poisson.
L'attività di spiking inoltre dipende dalle dinimiche caratteristiche l'area del cervello considerata e ci spno degli input non misurati da altre aree cerebrali

Nel modello LFADS, le dinamiche sottostanti (presupposto 1) sono generate da una rete neurale ricorrente, il "generatore". Questa rete estrae "fattori dinamici" usati per generare e inferire i firing rates dei neuroni registrati. I firing rates inferiti
Le condizioni iniziali e gli input per la rete generatrice (presupposti 2 e 3) vengono estratti dai dati di spiking per ogni prova tramite altre reti neurali ricorrenti, l'"encoder" e il "controller". Oltre alle sequenze di spike binari, nessun'altra informazione specifica della prova viene fornita al modello.

LFADS sfrutta la capacità delle reti neurali ricorrenti non lineari di riprodurre complessi schemi temporali di attività che stanno alla base dei dati neurali. A differenza dei metodi convenzionali, LFADS combina informazioni ottenute da tutti i neuroni registrati in tutte le prove, producendo tassi di spiking de-noised per ogni neurone in ogni prova.

Il metodo è stato applicato a vari dataset provenienti dalle corteccie motorie e premotorie di macachi rhesus e dalla corteccia motoria umana, mostrando che i tassi di spiking estratti da LFADS possono essere utilizzati per stimare variabili comportamentali in modo significativamente più accurato rispetto ad altre tecniche. LFADS cattura inoltre caratteristiche dei dati su molteplici scale temporali e può combinare dati da sessioni di registrazione non sovrapposte per migliorare le prestazioni su ogni sessione. Infine, LFADS dimostra la capacità di inferire input a un circuito neurale analizzando dati da un compito di raggiungimento del braccio con una perturbazione a metà prova.

Inoltre, le osservazioni hanno un modello di rumore (in questo caso Poisson), 
quindi viene anche creato una versione denoise delle osservazioni, 
ad esempio i tassi sottostanti di una distribuzione di Poisson dati i conteggi degli eventi osservati.
La struttura dati principale è un dizionario di dizionari di dati con una struttura specifica:

Il dizionario di livello superiore contiene nomi (stringhe) associati a dizionari di dati specifici.

Il dizionario di dati nested contiene le seguenti chiavi principali:
'train_data' e 'valid_data', i cui valori sono i dati di addestramento e di convalida corrispondenti, 
con forma ExTxD, dove E è il numero di esempi, T è il numero di passi temporali e 
D è il numero di dimensioni dei dati.
'train_ext_input' e 'valid_ext_input', che contengono input esterni noti al sistema in fase
di modellazione, con forma ExTxI, dove E è il numero di esempi, T è il numero di passi 
temporali e I è il numero di dimensioni degli input.
'alignment_matrix_cxf' e 'alignment_bias_c', che sono utilizzati per allineare i canali dei
dati quando si utilizzano dati da più giorni.
Se si esegue LFADS su dati in cui i tassi veri sono noti per alcune prove,
è possibile aggiungere tre ulteriori campi per scopi di tracciamento: 'train_truth', 
'valid_truth' e 'conversion_factor'. Questi campi hanno le stesse dimensioni di 'train_data'
e 'valid_data', ma rappresentano i tassi sottostanti delle osservazioni. 
Infine, c'è il campo 'conversion_factor' che può essere utilizzato per la conversion
e di scala per rappresentare graficamente i veri tassi di scarica sottostanti.

In sintesi, LFADS è un metodo per l'analisi di serie temporali che suddivide i
dati in diversi componenti e fornisce una struttura dati organizzata per il 
suo utilizzo nell'analisi e nella visualizzazione dei risultati.
