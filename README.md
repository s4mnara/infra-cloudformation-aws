
# IaC AWS - CloudFormation

Este repositório contém **templates de Infraestrutura como Código (IaC)** para AWS usando **CloudFormation**.  
Ele foi desenvolvido para fins de estudo e demonstração de boas práticas de automação, padronização, replicação e segurança em ambientes de nuvem.

---

## **Estrutura do repositório**

```

iac-aws-cloudformation/
├── templates/
│   ├── vpc-ec2-s3.yaml           # Template básico: VPC + EC2 + S3
│   └── vpc-ec2-asg-s3.yaml       # Template avançado: VPC + Auto Scaling Group + S3
├── scripts/
│   ├── deploy.sh                 # Script Bash para deploy (Linux/macOS)
│   └── deploy.ps1                # Script PowerShell para deploy (Windows)
├── README.md                      # Este arquivo
└── LICENSE                        # Licença MIT

````

---

## **Pré-requisitos**

Antes de utilizar os templates, você precisa ter:

- Conta AWS configurada  
- AWS CLI instalada e configurada (`aws configure`)  
- Par de chaves SSH (KeyPair) criado na AWS  

Opcional: Git Bash ou WSL para rodar o `deploy.sh` no Windows.

---

## **Templates Disponíveis**

### 1️⃣ Template Básico: `vpc-ec2-s3.yaml`

Cria:

- VPC com subnet pública  
- Internet Gateway e Route Table  
- Security Group com SSH e HTTP  
- Instância EC2  
- Bucket S3 com versionamento  

**Outputs**:

| Output       | Exemplo de Valor          |
|--------------|--------------------------|
| EC2PublicIP  | 54.233.123.45            |
| S3BucketName | meu-bucket-iac-123456    |

---

### 2️⃣ Template Avançado: `vpc-ec2-asg-s3.yaml`

Cria:

- VPC com subnet pública  
- Internet Gateway e Route Table  
- Security Group com SSH e HTTP  
- Launch Template para EC2  
- Auto Scaling Group (replicação automática de instâncias)  
- Bucket S3 com versionamento  

**Outputs**:

| Output       | Exemplo de Valor               |
|--------------|-------------------------------|
| ASGName      | MyAutoScalingGroup            |
| S3BucketName | meu-bucket-iac-avancado-123456 |

---

## **Scripts de Deploy**

### 1️⃣ `deploy.sh` (Linux/macOS)

- Executa qualquer template via AWS CLI.  
- Uso:

```bash
bash scripts/deploy.sh templates/vpc-ec2-asg-s3.yaml meu-stack MinhaChave
````

* Parâmetros:

  * `template.yaml` → Template YAML/JSON
  * `STACK_NAME` → Nome da stack CloudFormation
  * `KEY_NAME` → Nome do KeyPair SSH

> ⚠️ No Windows PowerShell, rode via Bash (Git Bash ou WSL).

---

### 2️⃣ `deploy.ps1` (Windows PowerShell)

* Executa qualquer template via AWS CLI nativamente no Windows.
* Uso:

```powershell
.\scripts\deploy.ps1 `
    -TemplateFile templates\vpc-ec2-asg-s3.yaml `
    -StackName meu-stack `
    -KeyName MinhaChave `
    -InstanceType t2.micro `
    -MinSize 1 `
    -MaxSize 2
```

* Parâmetros:

| Parâmetro    | Obrigatório | Descrição                                 |
| ------------ | ----------- | ----------------------------------------- |
| TemplateFile | Sim         | Caminho para o arquivo YAML/JSON          |
| StackName    | Sim         | Nome da stack a ser criada                |
| KeyName      | Sim         | Nome do KeyPair SSH                       |
| InstanceType | Não         | Tipo da instância EC2 (default: t2.micro) |
| MinSize      | Não         | Número mínimo de instâncias no ASG        |
| MaxSize      | Não         | Número máximo de instâncias no ASG        |

* Para template básico (sem ASG), ignore `MinSize` e `MaxSize`.

---

## **Como Usar**

### Via AWS Console

1. Acesse [CloudFormation Console](https://console.aws.amazon.com/cloudformation).
2. Clique em **Create stack → With new resources (standard)**.
3. Faça upload do template desejado (`vpc-ec2-s3.yaml` ou `vpc-ec2-asg-s3.yaml`).
4. Preencha os **Parameters** conforme necessário.
5. Clique em **Next → Next → Create stack**.
6. Acompanhe a criação no console.

---

### Via AWS CLI

Exemplo para template avançado:

```bash
aws cloudformation create-stack \
  --stack-name meu-stack \
  --template-body file://templates/vpc-ec2-asg-s3.yaml \
  --parameters ParameterKey=KeyName,ParameterValue=MinhaChave \
               ParameterKey=InstanceType,ParameterValue=t2.micro \
               ParameterKey=MinSize,ParameterValue=1 \
               ParameterKey=MaxSize,ParameterValue=2 \
  --capabilities CAPABILITY_NAMED_IAM
```

---

## **Boas Práticas**

* Use **nomes únicos** para buckets S3.
* Restrinja **Security Groups** a IPs confiáveis em produção.
* Use **tags** para identificar ambientes (dev/stage/prod).
* Teste sempre em uma conta sandbox antes de produção.
* Versione os templates no GitHub para manter histórico e padronização.





