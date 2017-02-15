Script VoxForge
=============

Following the tutorial offered by VoxForge, this project contains a full script to create acoustic model for the Julius Decoder using the HTK toolkit.

### Directories

| Type      | Name                              | Function                     		        |
| --------- | --------------------------------- | --------------------------------------------- |
| Directory | [clara](clara)            	| Contain grammar, voca and wavs.		|
| Directory | [htk](htk)                  	| Speech Recognition toolkit.		        |
| Directory | [julius-4.3.1](julius-4.3.1)      | Speech recognition engine.                    |
| Directory | [scripts](scripts)                | Contains the base scripts to generate LM.	|
| File	    | [grammar.sh](grammar.sh)          | Executes programs to generate the LM.		|
| File	    | [manage_files.sh](manage_files.sh)| Manages files to run the scripts.		|
| File	    | [setup.sh](setup.sh)  		| Installs dependencies.			|
| File	    | [run_all.sh](run_all.sh)          | Runs all scripts.				|
| File	    | [README.md](README.md)            | General instructions of the project. 		|
| File	    | [.gitignore](.gitignore)          | Files/folders ignored by git.			|


### Prepare Data

Add your grammar, voca, jconf, wavs, lexicon and prompts on [clara](clara) folder.

### Run
```
$ chmod +x setup.sh
$ chmod +x run_all.sh
$ ./setup.sh
$ ./run_all.sh
```

### TODO
- Let more general on scripts the folder that contains voca, grammar and wav.

### Author
- @Dayof
	- Dayanne Fernandes da Cunha
	- dayannefernandesc@gmail.com


