# Get-GPOVersionReport
Group policy version report across all DCs

If GPO is not replicated across all domain controllers you will face GPO applying problems, and before you start to troubleshoot AD replication or SYSVOL replication, you can start running this report to get which GPO is impacted or not up-to-date across all domain controllers.
then run CMD command at DC to check dfr rplication state

For /f %i IN ('dsquery server -o rdn') do @echo %i && @wmic /node:"%i" /namespace:\\root\microsoftdfs path dfsrreplicatedfolderinfo WHERE replicatedfoldername='SYSVOL share' get replicationgroupname,replicatedfoldername,state

or to check AD partitions Replication

repadmin /syncall /APeD



.\Get-GPOVersionReport.ps1 -guid 457A5DA2-7A53-4277-9F29-E5AA9AB3DC7F

![image](https://user-images.githubusercontent.com/130890375/232291737-8be137b3-b8bc-469d-ab85-8c98cf92d6cd.png)


![image](https://user-images.githubusercontent.com/130890375/232291703-4ffcac0d-770b-4755-b338-74d10271739b.png)
