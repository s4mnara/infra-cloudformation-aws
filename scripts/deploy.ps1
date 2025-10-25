<#
.SYNOPSIS
Deploy de templates CloudFormation via PowerShell

.DESCRIPTION
Este script realiza o deploy de um template CloudFormation na AWS, passando os parâmetros necessários.

.PARAMETER TemplateFile
Caminho para o arquivo YAML/JSON do template.

.PARAMETER StackName
Nome da stack que será criada na AWS.

.PARAMETER KeyName
Nome do par de chaves SSH existente na AWS.

.PARAMETER InstanceType
Opcional. Tipo da instância EC2 (ex.: t2.micro).

.PARAMETER MinSize
Opcional. Número mínimo de instâncias no ASG (apenas para template avançado).

.PARAMETER MaxSize
Opcional. Número máximo de instâncias no ASG (apenas para template avançado).

.EXAMPLE
.\deploy.ps1 -TemplateFile templates\vpc-ec2-asg-s3.yaml -StackName meu-stack -KeyName MinhaChave -InstanceType t2.micro -MinSize 1 -MaxSize 2
#>

param(
    [Parameter(Mandatory=$true)][string]$TemplateFile,
    [Parameter(Mandatory=$true)][string]$StackName,
    [Parameter(Mandatory=$true)][string]$KeyName,
    [string]$InstanceType = "t2.micro",
    [int]$MinSize,
    [int]$MaxSize
)

# Construir lista de parâmetros para AWS CLI
$awsParams = @(
    "ParameterKey=KeyName,ParameterValue=$KeyName",
    "ParameterKey=InstanceType,ParameterValue=$InstanceType"
)

# Adicionar MinSize/MaxSize se foram fornecidos
if ($MinSize) { $awsParams += "ParameterKey=MinSize,ParameterValue=$MinSize" }
if ($MaxSize) { $awsParams += "ParameterKey=MaxSize,ParameterValue=$MaxSize" }

# Executar o deploy
Write-Host "Criando stack '$StackName' a partir do template '$TemplateFile'..."
aws cloudformation create-stack `
    --stack-name $StackName `
    --template-body file://$TemplateFile `
    --parameters $awsParams `
    --capabilities CAPABILITY_NAMED_IAM

Write-Host "Comando enviado. Verifique o progresso no AWS CloudFormation Console."
