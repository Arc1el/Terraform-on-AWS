# Terraform Settings, Providers & Resource Blocks

소유자: 익명
최종 편집 일시: 2023년 4월 12일 오후 3:54
태그: AWS, Terraform

## 서울 리전, Terraform v1.4.4에 맞게 소스코드를 수정하였습니다.

[terraform-on-aws-ec2/03-Terraform-Settings-Providers-Resources/terraform-manifests at main · Arc1el/terraform-on-aws-ec2](https://github.com/Arc1el/terraform-on-aws-ec2/tree/main/03-Terraform-Settings-Providers-Resources/terraform-manifests)

---

## **Terraform Settings, Providers & Resource Blocks**

### **Step-01: Settings, Providers, Resources, File Function**

- 🔗 [Terraform Settings](https://developer.hashicorp.com/terraform/language/settings)
    - **Terraform 설정**
        
        ```json
        terraform {
        	**# code**
        }
        ```
        
        - `terraform` 블록에는 Terraform의 동작과 관련된 여러 설정이 포함됩니다.
        - 블록 내에서는 `terraform`  상수값만 사용 할 수 있습니다.
        - 인수는 리소스, 입력변수 등과 같은 명명된 개체를 참조 할 수 없습니다.
    - **🔗 [Terraform 클라우드 구성](https://developer.hashicorp.com/terraform/language/settings/terraform-cloud)**
    - **🔗 [Terraform 백엔드 구성](https://developer.hashicorp.com/terraform/language/settings/backends/configuration)**
    - **Terraform 버전 지정**
        
        ```json
        terraform {
          required_providers {
            aws = {
              **version = "~> 2.13.0"**
            }
            random = {
              version = ">= 2.1.2"
            }
          }
        
          **required_version = "~> 0.12.29"**
        }
        ```
        
        - `required_providers` 블록은 Terraform이 사용할 Provider들을 정의합니다.
        이 경우, `aws` Provider와 `random` Provider가 정의되어 있습니다.
        `aws` Provider의 버전은 "~> 2.13.0"으로 지정되어 있으며,
         `random` Provider의 버전은 ">= 2.1.2"으로 지정되어 있습니다.
        - `required_version` 블록은 이 Terraform 코드가 작동할 수 있는 최소 버전을 지정합니다.
        이 코드에서는 "~> 0.12.29" 버전을 요구하고 있습니다.
        이것은 Terraform 0.12.29 이상 버전이 필요하며, 0.13 이상 버전은 지원하지 않음을 의미합니다.
    - ****공급자 요구 사항 지정****
        
        ```json
        terraform  { 
          required_providers  { 
            aws  =  { 
              버전  =  ">= 2.7.0" 
              소스  =  "hashicorp/aws" 
            } 
          } 
        }
        ```
        
        - 블록 `required_providers`은 현재 모듈에 필요한 모든 공급자를 지정하고 각 로컬 공급자 이름을 소스 주소 및 버전 제약 조건에 매핑합니다.
    - ****실험적 언어 기능****
        
        ```json
        terraform  { 
          실험  =  [ 예 ] 
        }
        ```
        
        - `experiments` 실험적 기능을 사용할 수 있는 릴리스에서는 블록 내부에 인수를 설정하여 모듈별로 활성화할 수 있습니다
    - ****제공자에게 메타데이터 전달****
        
        ```json
        terraform {
          provider_meta "my-provider" {
            hello = "world"
          }
        }
        ```
        
- 🔗 [Terraform Providers](https://developer.hashicorp.com/terraform/language/providers)
- 🔗 [Terraform Resources](https://developer.hashicorp.com/terraform/language/resources)
- 🔗 [Terraform File Function](https://developer.hashicorp.com/terraform/language/functions/file)
    
    

### **Step-02: Terraform Settings Block 생성하기**

[📁c1-versions.tf](https://github.com/Arc1el/terraform-on-aws-ec2/blob/main/03-Terraform-Settings-Providers-Resources/terraform-manifests/c1-versions.tf)

- 선행 :
    - [🔗 [Terraform Settings](https://developer.hashicorp.com/terraform/language/settings)](Terraform%20Settings,%20Providers%20&%20Resource%20Blocks%20536e47229b474183b8a5f1aaa4fac485.md) 이해하기
    - Code
        
        ```json
        terraform {
          required_version = "~> 0.14" # which means any version equal & above 0.14 like 0.15, 0.16 etc and < 1.xx
          required_providers {
            aws = {
              source  = "hashicorp/aws"
              version = "~> 3.0"
            }
          }
        }
        ```
        

### **Step-03: Terraform Providers Block 생성하기**

- 선행 :
    - [🔗 [Terraform Providers](https://developer.hashicorp.com/terraform/language/providers) ](Terraform%20Settings,%20Providers%20&%20Resource%20Blocks%20536e47229b474183b8a5f1aaa4fac485.md) 이해하기
    - AWS CLI에서 AWS Credentials 설정하기
        - [**Terraform & AWS CLI 설치** ](Terraform%20&%20AWS%20CLI%20%E1%84%89%E1%85%A5%E1%86%AF%E1%84%8E%E1%85%B5%2030ec176c917340818445dda4caffcdeb.md)
    - Code
        
        ```json
        provider "aws" {
          region  = us-east-1
          profile = "default"
        }
        ```
        

### **Step-04: Terraform Resource Block 생성하기**

[📁c2-ec2instance.tf](https://github.com/Arc1el/terraform-on-aws-ec2/blob/main/03-Terraform-Settings-Providers-Resources/terraform-manifests/c2-ec2instance.tf)

- 선행 :
    - 다음 문서들 이해하기
        - [Resources](https://www.terraform.io/docs/language/resources/index.html)
        - [EC2 Instance Resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)
        - [File Function](https://www.terraform.io/docs/language/functions/file.html)
        - [Resources - Argument Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#argument-reference)
        - [Resources - Attribute Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#attributes-reference)
    - Code
        
        ```json
        # Resource: EC2 Instance
        resource "aws_instance" "myec2vm" {
          ami = "ami-0533f2ba8a1995cf9"
          instance_type = "t3.micro"
          user_data = file("${path.module}/app1-install.sh")
          tags = {
            "Name" = "EC2 Demo"
          }
        }
        ```
        

### **Step-05: (추가 : 업데이트) vpc, subnet, igw, rtb, sg, sgr**

```json
# Make VPC
resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "myVPC"
    "hmkim" = "terraform-vpc"
  }
}

# Make subnet
resource "aws_subnet" "example" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = {
    "hmkim" = "terraform-subnet"
    Name = "mySubnet"
  }
}

# Make routing Table
resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "Public rtb"
  }
}

resource "aws_route" "public_rtb" {
  route_table_id         = aws_route_table.public_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Make routing table association
resource "aws_route_table_association" "public_rtb" {
  subnet_id      = aws_subnet.example.id
  route_table_id = aws_route_table.public_rtb.id
}
```

```bash
resource "aws_instance" "myec2vm" {
  ami = "ami-09cd5dd529c3c1f40"
  instance_type = "t3.micro"
  user_data = file("${path.module}/app1-install.sh")
	
	# update subnet id
  subnet_id = aws_subnet.example.id

	# update security group
  vpc_security_group_ids = ["${aws_security_group.webserver-sg.id}"]
  tags = {  
    "Name" = "EC2 Demo"
    "hmkim" = "EC2"
  }
}
```

```bash
# Make internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "IGW"
    "hmkim" = "igw"
  }
}

# Make Security group
resource "aws_security_group" "webserver-sg" {
    name = "webserver-sg"
    description = "allow 22, 80"
    vpc_id = aws_vpc.default.id
}

# Make Security group rule
# Inbound
resource "aws_security_group_rule" "webserver-sg-ssh" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    security_group_id = aws_security_group.webserver-sg.id
    description = "ssh"
}

resource "aws_security_group_rule" "webserver-sg-http" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    security_group_id = aws_security_group.webserver-sg.id
    description = "http"
}

# Outbound
resource "aws_security_group_rule" "webserver-sg-outbound" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
    security_group_id = aws_security_group.webserver-sg.id
    description = "outbound"
}
```

### **Step-06: app1-install.sh 살펴보기**

[📁app1-install.sh](https://github.com/Arc1el/terraform-on-aws-ec2/blob/main/03-Terraform-Settings-Providers-Resources/terraform-manifests/app1-install.sh)

![Untitled](Terraform%20Settings,%20Providers%20&%20Resource%20Blocks%20536e47229b474183b8a5f1aaa4fac485/Untitled.png)

```bash
#! /bin/bash
# Instance Identity Metadata Reference - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-identity-documents.html
sudo yum update -y
sudo yum install -y httpd
sudo systemctl enable httpd
sudo service httpd start  
sudo echo '<h1>Welcome to StackSimplify - APP-1</h1>' | sudo tee /var/www/html/index.html
sudo mkdir /var/www/html/app1
sudo echo '<!DOCTYPE html> <html> <body style="background-color:rgb(250, 210, 210);"> <h1>Welcome to Stack Simplify - APP-1</h1> <p>Terraform Demo</p> <p>Application Version: V1</p> </body></html>' | sudo tee /var/www/html/app1/index.html
sudo curl http://169.254.169.254/latest/dynamic/instance-identity/document -o /var/www/html/app1/metadata.html
```

### **Step-07: Terraform 커맨드 실행하기**

```bash
# Initialize terraform
terraform init
Observation:
1) Initialized Local Backend
2) Downloaded the provider plugins (initialized plugins)
3) Review the folder structure ".terraform folder"
```

![Untitled](Terraform%20Settings,%20Providers%20&%20Resource%20Blocks%20536e47229b474183b8a5f1aaa4fac485/Untitled%201.png)

```bash
# Terraform Validate
terraform validate
Observation:
1) If any changes to files, those will come as printed in stdout (those file names will be printed in CLI)
```

![Untitled](Terraform%20Settings,%20Providers%20&%20Resource%20Blocks%20536e47229b474183b8a5f1aaa4fac485/Untitled%202.png)

```bash
# Terraform Plan
terraform plan
Observation:
1) No changes - Just prints the execution plan
```

![Untitled](Terraform%20Settings,%20Providers%20&%20Resource%20Blocks%20536e47229b474183b8a5f1aaa4fac485/Untitled%203.png)

```bash
# Terraform Apply
terraform apply 
[or]
terraform apply -auto-approve
Observations:
1) Create resources on cloud
2) Created terraform.tfstate file when you run the terraform apply command
```

![Untitled](Terraform%20Settings,%20Providers%20&%20Resource%20Blocks%20536e47229b474183b8a5f1aaa4fac485/Untitled%204.png)

![Untitled](Terraform%20Settings,%20Providers%20&%20Resource%20Blocks%20536e47229b474183b8a5f1aaa4fac485/Untitled%205.png)

### References

[Terraform Settings - Configuration Language | Terraform | HashiCorp Developer](https://developer.hashicorp.com/terraform/language/settings)

[Providers - Configuration Language | Terraform | HashiCorp Developer](https://developer.hashicorp.com/terraform/language/providers)

[Resources Overview - Configuration Language | Terraform | HashiCorp Developer](https://developer.hashicorp.com/terraform/language/resources)

[file - Functions - Configuration Language | Terraform | HashiCorp Developer](https://developer.hashicorp.com/terraform/language/functions/file)