%%% cambiare opportunamente i nomi delle directory
%%% La parte di generazione dei dati può essere skippata fino a riga...

name_fold='/home/zlollo/CNR'

folder_path_lfads_run_manager=fullfile(name_fold, 'lfads-run-manager/src');
folder_path_lfads_models=fullfile(name_fold,'lfads/')


addpath(genpath(folder_path_lfads_run_manager));
addpath(genpath(folder_path_lfads_models));

%%% Generiamo dataset sintetici di spiking data generati da un 
%% attrattore di lorenz 3 dimensionale come sistema dinamico
%% sotostante inizializato da 65 condizioni iniziali


datasetPath = fullfile(name_fold, 'lorenz_example/datasets');
% generate demo datasets
if ~exist(fullfile(datasetPath, 'dataset001.mat'), 'file')
    LFADS.Utils.generateDemoDatasets(datasetPath, 'nDatasets', 2);
end
dataPath = fullfile(name_fold, 'lorenz_example/datasets');
dc = LorenzExperiment.DatasetCollection(dataPath);
LorenzExperiment.Dataset(dc, 'dataset001.mat');
dc.name = 'lorenz_example';




% l'attrattore di Lorenz viene utilizzato come base per generare dati 
% sintetici di attività neuronale. Consta di diversi passaggi:

% Generazione di Matrici Casuali: Vengono create matrici casuali che
% fungono da "proiezioni" per le tre dimensioni dell'attrattore di Lorenz.
% Queste proiezioni sono utilizzate per trasformare i dati dell'attrattore 
% (firing rates) dei neuroni sintetici.

%Condizioni Iniziali e Traiettorie Dinamiche: Le condizioni iniziali e le
% traiettorie dinamiche dell'attrattore di Lorenz rimangono costanti
% attraverso vari set di dati. Questo significa che ogni set di dati ha la
% stessa configurazione iniziale e segue lo stesso percorso nel tempo e
% nello spazio tridimensionale dell'attrattore.

% Variabilità dei Neuroni: Ogni set di dati contiene un numero variabile
% di neuroni, da 25 a 35. I firign rates a di questi neuroni sono generati
% proiettando la traiettoria dell'attrattore di Lorenz attraverso una
% matrice di lettura specifica del set di dati, aggiungendo un termine di
% bias e applicando l'esponenziale.

% Processo Poisson Inomogeneo: Le sequenze di spike (spiking data) sono 
% generate simulando un processo di Poisson inomogeneo, che è un modello
% statistico comunemente usato per descrivere la temporizzazione degli 
% spike neurali, con 20-30 prove per ogni condizione.

% L'uso dell'attrattore di Lorenz serve a creare dati di spike neurali
% che presentano una complessità e una variabilità simili a quelle
% osservate nei dati reali del cervello. I dati generati in questo modo possono essere utilizzati per testare algoritmi di analisi o per studiare come le reti neurali processano l'informazione dinamica e complessa.

% Un attrattore di Lorenz, quindi, è una rappresentazione di un sistema
% dinamico che, attraverso semplici equazioni differenziali, 
% crea un modello che mostra come un sistema possa evolvere nel tempo
% in modo non lineare e imprevedibile. È un esempio classico di un 
% sistema caotico che, nonostante la sua apparenza casuale, ha una 
% struttura deterministica sottostante. Nel caso dell'attività neuronale,
% questo tipo di dinamica può essere utile per modellare come gruppi di 
% neuroni possano sincronizzarsi o come possano emergere pattern di 
% attività complessi.

dc.loadInfo();
disp(dc.getDatasetInfoTable())

%% CReo una run collection che contenga tutti i giri in cui alleno il
% modello
runRoot = fullfile(name_fold, 'lorenz_example/runs');
%%% occhio che quando poi da shell chiami run_lfasqueue.py fa riferimento
% alla cartella examplesingle etc...
rc = LorenzExperiment.RunCollection(runRoot, 'exampleSingleRun', dc);

date=14112023
rc.version = date;

par = LorenzExperiment.RunParams;
par.name = 'first_attempt'; % completely optional
par.spikeBinMs = 2; % rebin the data at 2 ms
par.c_co_dim = 0; % no controller --> no inputs to generator
par.c_batch_size = 150; % must be < 1/5 of the min trial count
par.c_factors_dim = 8; % and manually set it for multisession stitched models
par.c_gen_dim = 64; % number of units in generator RNN
par.c_ic_enc_dim = 64; % number of units in encoder RNN
par.c_learning_rate_stop = 1e-3; % we can stop training early for the demo

rc.addParams(par);

par



% Definisco ub RunSpec, che indica quali datasets sono incclusi
% così come il nome della Runspec
ds_index = 1;
runSpecName = dc.datasets(ds_index).getSingleRunName(); 
runSpec = LorenzExperiment.RunSpec(runSpecName, dc, ds_index);

% Aggiung questa RunSpec alla  RunCollection
rc.addRunSpec(runSpec);

% Aggiungendo un return qui ti permette di chiamare questo script per 
%ricreare tutti gli oggetti qui presenti per analisi successive dopo 
%che i modelli LFADS sono stati effettivamente addestrati. 
%Il codice sottostante imposterà le esecuzioni di addestramento 
%LFADS su disco la prima volta, e dovrebbe essere eseguito manualmente una volta.
return;

% Genera tutti i file dati occorrenti a fari girare LFADS
rc.prepareForLFADS();


% Crea uno script Python che "allena" tutti i giri LFADS usando un
% distribuendo carico di lavoro tra CPUs and GPUs (elimina se usi tf 1.1)
% you should set display to a valid x display
% Ci sono altre opzionoi disponibili
% ricorda di chiamare il virtualenv con il nome dell'ambiente creato
rc.writeShellScriptRunQueue('display', 0, 'virtualenv', 'tf_cpu');

