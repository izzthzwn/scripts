.\CopyToPSPath.ps1
Import-Module AzFilesHybrid
Connect-AzAccount #-DeviceCode
Set-AzContext -subscription 5f782fe2-8948-4fd8-8bce-a09ad5d3cb62 # PROD
Set-AzContext -subscription b5a67ad5-d38a-4258-aa5e-31e39d3b709f #DEV
Set-AzContext -subscription b9c4e2a3-a10d-4a47-94b7-0fb93b30690f # UAT
Set-AzContext -subscription e2c2906c-8901-4443-a9ee-50ffe123541a #IAC PROD
Set-AzContext -subscription 1c334150-08b8-4088-9170-074fa26a9926 #IAC UAT
Set-AzContext -subscription 2be5068f-e0ac-4d57-aedc-96bc9798a265 #IAC DEV
Join-AzStorageAccountForAuth -ResourceGroupName 'PTAZSG-IAC-PROD-DPIP-RG' -StorageAccountName "ptazsg1dpipstr" -Domain 'petronas.petronet.dir' -DomainAccountType 'ComputerAccount' -OrganizationalUnitName 'Non-Windows Server' -OverwriteExistingADObject
Disconnect-AzAccount

Debug-AzStorageAccountAuth -StorageAccountName "ptsg1avevastrg" -ResourceGroupName "PTAZSG-IAC-PROD-AVEVA-RG" -Verbose | Out-File ".\NewLog.txt"

<#
Name                                         Id                                   TenantId                             State  
----                                         --                                   --------                             -----  
PTAZSG-PROD ENVIRONMENT                      5f782fe2-8948-4fd8-8bce-a09ad5d3cb62 3b2e8941-7948-4131-978a-b2dfc7295091 Enabled
PTAZSG-DEV ENVIRONMENT                       b5a67ad5-d38a-4258-aa5e-31e39d3b709f 3b2e8941-7948-4131-978a-b2dfc7295091 Enabled
PTAZSG-UAT ENVIRONMENT                       b9c4e2a3-a10d-4a47-94b7-0fb93b30690f 3b2e8941-7948-4131-978a-b2dfc7295091 Enabled
PTAZSG-IAC-PROD ENVIRONMENT                  e2c2906c-8901-4443-a9ee-50ffe123541a 3b2e8941-7948-4131-978a-b2dfc7295091 Enabled
PTAZSG-IAC-DEV ENVIRONMENT                   2be5068f-e0ac-4d57-aedc-96bc9798a265 3b2e8941-7948-4131-978a-b2dfc7295091 Enabled
PTAZSG-IAC-UAT ENVIRONMENT                   1c334150-08b8-4088-9170-074fa26a9926 3b2e8941-7948-4131-978a-b2dfc7295091 Enabled
PTAZHK-DR-PROD-ENVIRONMENT                   2a5b466c-e76e-4cc3-bf18-11a6ef3bc53f 3b2e8941-7948-4131-978a-b2dfc7295091 Enabled
Halliburton POC                              82b87f22-6516-4f45-88b5-f32d12d21207 3b2e8941-7948-4131-978a-b2dfc7295091 Enabled
PTAZHK-DR-PCIDSS ENVIRONMENT                 ad5debc5-41c6-4d21-a3ee-310997bbfc03 3b2e8941-7948-4131-978a-b2dfc7295091 Enabled
PTAZBR-DEV ENVIRONMENT                       59a7a69c-f452-4b7b-8715-8fc7756e396a 3b2e8941-7948-4131-978a-b2dfc7295091 Enabled
PTAZSCUS -DR-PCIDSS ENVIRONMENT              9e3d0db1-a3dd-4c22-a8be-fbae2cb2b3a0 3b2e8941-7948-4131-978a-b2dfc7295091 Enabled
PTAZWEU-DEV ENVIRONMENT                      b6ebb175-baa3-49a1-a493-d6aded94e9d0 3b2e8941-7948-4131-978a-b2dfc7295091 Enabled
PTAZSCUS-CORE ENVIRONMENT                    77e7ce15-02ec-4beb-bf56-383894f57669 3b2e8941-7948-4131-978a-b2dfc7295091 Enabled
Myminutes (PROD)                             28bc2e9f-6879-40cf-8cf4-40411860db14 3b2e8941-7948-4131-978a-b2dfc7295091 Enabled
PTAZSCUS-PROD ENVIRONMENT                    1cd65eea-84f4-48da-bdcf-c5b956b0eda0 3b2e8941-7948-4131-978a-b2dfc7295091 Enabled
PTAZSG-CORE ENVIRONMENT                      8a71ac81-04ed-4e9b-adea-c852951f4d69 3b2e8941-7948-4131-978a-b2dfc7295091 Enabled
PTAZSCUS-CORE VNet                           293b676a-3a51-4502-ad62-a2a26746a471 3b2e8941-7948-4131-978a-b2dfc7295091 Enabled
PTAZWEU-CORE ENVIRONMENT                     4a5efd2d-077d-4ab0-987b-880bd0b0db95 3b2e8941-7948-4131-978a-b2dfc7295091 Enabled
PTAZSCUS -DR-UAT ENVIRONMENT                 20988a81-d92b-403d-b4e4-b7b171be64c7 3b2e8941-7948-4131-978a-b2dfc7295091 Enabled
PTAZWEU-PROD ENVIRONMENT                     69fc90d0-5e9f-4cc2-85bb-55c12618fee2 3b2e8941-7948-4131-978a-b2dfc7295091 Enabled
PTAZSCUS -DR-PROD-ENVIRONMENT                4d4965a2-3d98-436c-a1ea-a0cf383f46c5 3b2e8941-7948-4131-978a-b2dfc7295091 Enabled
PTAZSG-CoC-Lab ENVIRONMENT                   1cb9e211-f425-4519-ac3d-5f8b148e1728 3b2e8941-7948-4131-978a-b2dfc7295091 Enabled
Microsoft Azure Enterprise                   48c36154-18f6-4075-9884-84eb616efd5a 3b2e8941-7948-4131-978a-b2dfc7295091 Enabled
PTAZHK-DR-UAT ENVIRONMENT                    5c79dfcf-687e-4d38-8f01-4fa4ee0404d2 3b2e8941-7948-4131-978a-b2dfc7295091 Enabled
PTAZHK-DR-CORE ENVIRONMENT                   03eb7cf8-7766-4118-ab23-fadafadeff4b 3b2e8941-7948-4131-978a-b2dfc7295091 Enabled
PTAZBR-UAT ENVIRONMENT                       af2f590a-a606-48d3-826c-eed44e9049a9 3b2e8941-7948-4131-978a-b2dfc7295091 Enabled
PTAZHK-DR-DEV ENVIRONMENT                    a6a30883-048f-4c48-a8a6-18c67547fb32 3b2e8941-7948-4131-978a-b2dfc7295091 Enabled
PETRONAS Microsoft Azure Enterprise          b4ff1bb8-5058-44a6-8807-0b0316e6e13a 3b2e8941-7948-4131-978a-b2dfc7295091 Enabled
Microsoft Azure Sponsorship(Converted to EA) 29c9beb8-9c69-4027-8969-bb017371c4a8 3b2e8941-7948-4131-978a-b2dfc7295091 Enabled
PTAZBR-CORE ENVIRONMENT                      a868ec10-b457-49b1-b094-13dedd7fa15a 3b2e8941-7948-4131-978a-b2dfc7295091 Enabled
PTAZWEU-UAT ENVIRONMENT                      01ebb304-946d-417b-9005-b72304c70ea6 3b2e8941-7948-4131-978a-b2dfc7295091 Enabled
PTAZSCUS -DR-DEV ENVIRONMENT                 2a6acc04-1f59-422b-8ce3-53c7fd75b35f 3b2e8941-7948-4131-978a-b2dfc7295091 Enabled
PTAZBR-PROD ENVIRONMENT                      3caaf296-fe14-41e6-8ba2-4f1dd8dfc7fd 3b2e8941-7948-4131-978a-b2dfc7295091 Enabled
#>