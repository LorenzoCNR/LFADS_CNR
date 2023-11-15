LFADS" (Latent Factor Analysis via Dynamical Systems) è un metodo utilizzato per decomporre dati 
di serie temporali in vari fattori, tra cui una condizione iniziale, un sistema dinamico generativo,
input di controllo per quel generatore e una descrizione a bassa dimensionalità dei dati osservati,
chiamata "fattori". Inoltre, le osservazioni hanno un modello di rumore (in questo caso Poisson), 
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
