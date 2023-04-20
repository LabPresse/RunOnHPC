# RunOnHPC
Use these bash scripts to automatically run multiple jobs on Agave.

# Requirements
In order for this to work you will need to download sshpass. To download sshpass youcan use
macOS:
```bash
brew install hudochenkov/sshpass/sshpass
```
linux:
```bash
yum install sshpass
```
Windows: try this -> https://stackoverflow.com/questions/37243087/how-to-install-sshpass-on-windows-through-cygwin

# Organization
In order to run these scripts you must organize your code in a certain way. In the next few sections we go over in detail how to do this.

## Local Credentials
In this repository you should save your ASU username and password in `_password_.txt` and `_username_.txt` directly in this repository. Make sure that these are inlcuded in .gitignore otherwise the world will have access to your info.
NOTE: this is clearly not the best way to do this, we will have to fix this in future versions.

## Local Data
All of your data, for all of your projects, should be stored in a single directory called "Data" that lives somewhere on your local machine. Within `Data/` you should have sub directories for each of your projects
```markdown
Data/
    MyProject/
        data1.txt
        data2.txt
    MyOtherProject/
        file.csv
    ...
```
You need to set up an environmental variable in your machine called "DATAPATH" that points to this directory. To create a DATAPATH environmental variable simply add this line to your ~/.bashrc file (~/.bash_profile on macOS):
```python
export DATAPATH="/path/to/your/data/"
```

## Local Projects
All of the code you want to run should be in a self contained directory. It cannot import code or modules from other directories. You should organize your code as follows
```markdown
MyProject/
    outfiles/
       where you save your results
    pics/
       where you save your figures
    env/
       environment stuff (if needed)
    src/
       your code
    main.py (or main.jl, main.h, etc.)
    ...
    other files (git stuff, license, etc.)
    ...
```
This is somewhat flexible, but the most important parts are: 1) all your results are only saved in `outfiles/` and `pics/`; 2) You run your code using a main file called "main.py", "main.jl", etc. We explain the main file next.

## Main File
Your main file should have all the code needed to execute your script. Your main file should load data using the environmental variable, DATAPATH, and it should not use local paths. For example to load a csv in python you would use
```python
import os
# Get data
datapath =  os.environ["DATAPATH"] + "Myproject/" + "file.csv"
data = # Load data
```
You should save all your results in a directory called `outfiles/`. These will be excluded when copying.
If you want to run over multiple files/parameters in parallel you must specify this using a system argument. For example
```python
import os
import sys
# Select file
files = ["file1.csv", "file2.csv"]
ID = 0
if len(sys.argv) > 1:
    ID = int(sys.argv[1])
file = files[ID]
# Load data
datapath =  os.environ["DATAPATH"] + "Myproject/" + file
data = # Load data
```

## Agave Orgainization.
In your home directory on Agave, `username@agave.asu.edu:/home/username`, you shoule have a directory called "Data" like
```markdown
home/
    username/
        Data/
```

## Agave Projects
When you run these scripts they will automatically copy all the code from your local machine to a directory in Agave with the same name plus a time tag. Slurm job information will be stored in a directory calld `.slurmfiles` within this directory.

# Running code
Now that we have organized our projects and data we are ready to run it! There are three steps
1) upload data to Agave
2) run analysis
3) download data from Agave
Lets cover these step by step

## Uplad Data
To upload data from a project within your data directory (see Organization - Local Data) run this in your terminal while in this directory
```bash
bash upload_data.sh MyProject
```

## Run code
To run your analysis code on Agave simply run this code while in this directory
```bash
bash run_on_cluster.sh path/to/local/project
```
You can also specify optional parameters:
-t or --time)
    Defaults to max time (7-00:00)
    Specifies the max time limit for Agave. Longer jobs have lower priority so for shor jobs it might be good to specify. Format is D-HH:MM where D is days, HH is hours, and MM is minutes.
-c or --num_cores
    Defaults to 1
    Specifies the number of cores to run on per job.
-j or --num_jobs
    Defaults to 1
    Specifies number of jobs/files to run over (see Organization -> Main File).
-D or --dirname
    Defaults to projectname+timestamp
    Specify name of save directory on Agave. This is in case you want to run analysis separately that your main results.
--nodes
    No default
    Specifies the nodes to run on. Can be "steve" for steves nodes or "htc" for htc nodes.
--language
    Defaults to python
    Language of your main file.

# Download results
To download your results run this from within this directory
```bash
bash get_from_cluster.sh path/to/project
```
This will download all the results from your Agave outfiles directories to your local directory.
Note that if you run the same project multiple times on Agave this will overwrite all but one version of your results, so make sure you save results of different runs with different file names!

