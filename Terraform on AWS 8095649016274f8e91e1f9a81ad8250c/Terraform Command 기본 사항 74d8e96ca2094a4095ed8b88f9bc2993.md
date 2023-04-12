# Terraform Command 기본 사항

소유자: 익명
최종 편집 일시: 2023년 4월 12일 오후 12:51
태그: AWS, Terraform

## **Terraform Command 기본 사항**

### **Step-01: 소개**

- 기본적인 Terraform Command 이해하기
    - terraform init
    - terraform validate
    - terraform plan
    - terraform apply
    - terraform destroy

### **Step-02: EC2 Instance와 VPC 생성을 위한 테라폼 코드**

- 전제조건
    - 사용된 AMI이미지에 대해 존재하지 않을경우 업데이트된 이미지를 사용
    - AWS Credentials가 설정되어있음
        - [**Terraform & AWS CLI 설치** ](Terraform%20&%20AWS%20CLI%20%E1%84%89%E1%85%A5%E1%86%AF%E1%84%8E%E1%85%B5%2030ec176c917340818445dda4caffcdeb.md) (참고)
- Code
    
    ```json
    # Terraform Settings Block
    terraform {
      required_providers {
        aws = {
          source  = "hashicorp/aws"
          #version = "~> 3.21" # Optional but recommended in production
        }
      }
    }
    
    # Provider Block
    provider "aws" {
      profile = "default" # AWS Credentials Profile configured on your local desktop terminal  $HOME/.aws/credentials
      region  = "ap-northeast-2"
    }
    
    resource "aws_vpc" "default" {
      cidr_block = "10.0.0.0/16"
    
      tags = {
        Name = "myVPC"
        "hmkim" = "terraform-vpc"
      }
    }
    
    resource "aws_subnet" "example" {
      vpc_id            = aws_vpc.default.id
      cidr_block        = "10.0.1.0/24"
      availability_zone = "ap-northeast-2a"
    
      tags = {
        "hmkim" = "terraform-subnet"
      }
    }
    
    # Resource Block
    resource "aws_instance" "terraformDemo" {
      ami           = "ami-09cd5dd529c3c1f40" # Amazon Linux in us-east-1, update as per your region
      instance_type = "t3.micro"
      subnet_id     = aws_subnet.example.id
    
      tags = {
        "hmkim" = "terraform-instance"
      }
    }
    ```
    
    - **`terraform`** 블록: 이 블록은 테라폼 설정을 지정합니다. 여기에서는 테라폼에서 AWS 공급자를 사용하도록 요구하며, 특정 버전이 아닌 최신 버전을 사용합니다.
    - **`provider`** 블록: 이 블록은 Terraform에게 AWS 자원을 생성할 때 사용할 AWS 공급자를 지정합니다. 이 구성에서는 기본 프로필을 사용하며, 리전은 **`ap-northeast-2`**로 설정됩니다.
    - **`resource "aws_vpc" "default"`** 블록: 이 블록은 AWS VPC를 생성합니다. VPC의 CIDR 블록은 **`10.0.0.0/16`**이며, VPC에 대한 태그를 지정합니다.
    - **`resource "aws_subnet" "example"`** 블록: 이 블록은 AWS 서브넷을 생성합니다. 이 서브넷은 **`aws_vpc.default`**에서 생성한 VPC에 속하며, CIDR 블록은 **`10.0.1.0/24`**입니다. 이 서브넷은 **`ap-northeast-2a`** 가용 영역에 있습니다.
    - **`resource "aws_instance" "terraformDemo"`** 블록: 이 블록은 EC2 인스턴스를 생성합니다. 이 인스턴스는 **`ami-09cd5dd529c3c1f40`** Amazon Linux AMI를 사용하며, 인스턴스 유형은 **`t3.micro`**입니다. 이 인스턴스는 **`aws_subnet.example`**에서 생성한 서브넷에 속합니다. 마지막으로, 이 인스턴스에 대한 태그를 지정합니다.

### **Step-03: Terraform Core Commands**

- 테라폼을 실행해봅니다
- Code
    
    ```bash
    # Initialize Terraform
    terraform init
    ```
    
    ![Untitled](Terraform%20Command%20%E1%84%80%E1%85%B5%E1%84%87%E1%85%A9%E1%86%AB%20%E1%84%89%E1%85%A1%E1%84%92%E1%85%A1%E1%86%BC%2074d8e96ca2094a4095ed8b88f9bc2993/Untitled.png)
    
    ```bash
    # Terraform Validate
    terraform validate
    ```
    
    ![Untitled](Terraform%20Command%20%E1%84%80%E1%85%B5%E1%84%87%E1%85%A9%E1%86%AB%20%E1%84%89%E1%85%A1%E1%84%92%E1%85%A1%E1%86%BC%2074d8e96ca2094a4095ed8b88f9bc2993/Untitled%201.png)
    
    ```bash
    # Terraform Plan to Verify what it is going to create / update / destroy
    terraform plan
    ```
    
    ![Untitled](Terraform%20Command%20%E1%84%80%E1%85%B5%E1%84%87%E1%85%A9%E1%86%AB%20%E1%84%89%E1%85%A1%E1%84%92%E1%85%A1%E1%86%BC%2074d8e96ca2094a4095ed8b88f9bc2993/Untitled%202.png)
    
    ```bash
    # Terraform Apply to Create EC2 Instance
    terraform apply
    ```
    
    ![Untitled](Terraform%20Command%20%E1%84%80%E1%85%B5%E1%84%87%E1%85%A9%E1%86%AB%20%E1%84%89%E1%85%A1%E1%84%92%E1%85%A1%E1%86%BC%2074d8e96ca2094a4095ed8b88f9bc2993/Untitled%203.png)
    
    ![Untitled](Terraform%20Command%20%E1%84%80%E1%85%B5%E1%84%87%E1%85%A9%E1%86%AB%20%E1%84%89%E1%85%A1%E1%84%92%E1%85%A1%E1%86%BC%2074d8e96ca2094a4095ed8b88f9bc2993/Untitled%204.png)
    

### **Step-04: Verify the EC2 Instance in AWS Management Console**

- AWS 콘솔 → EC2 → 인스턴스 생성 확인
    
    ![Untitled](Terraform%20Command%20%E1%84%80%E1%85%B5%E1%84%87%E1%85%A9%E1%86%AB%20%E1%84%89%E1%85%A1%E1%84%92%E1%85%A1%E1%86%BC%2074d8e96ca2094a4095ed8b88f9bc2993/Untitled%205.png)
    
- AWS 콘솔 → VPC → VPC 생성 확인
    
    ![Untitled](Terraform%20Command%20%E1%84%80%E1%85%B5%E1%84%87%E1%85%A9%E1%86%AB%20%E1%84%89%E1%85%A1%E1%84%92%E1%85%A1%E1%86%BC%2074d8e96ca2094a4095ed8b88f9bc2993/Untitled%206.png)
    

### **Step-05: Destroy Infrastructure**

- Destroy를 사용하여 생성된 인프라를 삭제합니다
    
    ```bash
    # Destroy EC2 Instance
    terraform destroy
    
    # Delete Terraform files 
    rm -rf .terraform*
    rm -rf terraform.tfstate*
    ```
    
    ![Untitled](Terraform%20Command%20%E1%84%80%E1%85%B5%E1%84%87%E1%85%A9%E1%86%AB%20%E1%84%89%E1%85%A1%E1%84%92%E1%85%A1%E1%86%BC%2074d8e96ca2094a4095ed8b88f9bc2993/Untitled%207.png)
    

### References