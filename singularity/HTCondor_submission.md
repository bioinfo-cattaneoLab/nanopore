# 1 In HTCondor we can run a job with a certain variable, in this case, we should use a job like [this](HTCondor_jobs/condor-wget.job) and the following command line. 
```
condor_submit -a "variable1=https://www.recas-bari.it/images/manuali/ITAManualeHTCondor.pdf" -a "variable2=/lustrehome/gianluca/documents/fileName.pdf -name ettore /lustehome/gianluca/jobs/<nome_del_job_> 
```

# 2 We can run a Singualarity container with a job and for do that I suggest to use a template like [this](HTCondor_jobs/singularity_template) for create a job that allow to execute corretly a job with Singulairty. Following we can see a non-specific command line and can we use as well all variable that we need.
```
condor_submit -name ettore <name_job>
```
