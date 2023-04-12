# Terraform Variables, Datasources

소유자: 익명
최종 편집 일시: 2023년 4월 12일 오후 4:26
태그: AWS, Terraform

## **Terraform Variables, Datasources**

### **Step-00: AWS EC2 키페어 준비**

- `terraform-key` 라는 이름을 가진 키페어를 준비합니다. (EC2 인스턴스에 접근 할 수 있도록) ****

### **Step-01: 소개**

- **Terraform Concepts**
    - Terraform Input Variables
    - Terraform Datasources
    - Terraform Output Values
- 내용
    1. Terraform `Input Variable` basics
        
        [Input Variables - Configuration Language | Terraform | HashiCorp Developer](https://developer.hashicorp.com/terraform/language/values/variables)
        
        - AWS Region
        - Instance Type
        - Key Name
    2. Define `Security Groups` and Associate them as a `List item` to AWS EC2 Instance
        - vpc-ssh
        - vpc-web
    3. Learn about Terraform `Output Values`
        - Public IP
        - Public DNS
    4. Get latest EC2 AMI ID Using `Terraform Datasources` concept
    5. We are also going to use existing EC2 Key pair `terraform-key`
    6. Use all the above to create an EC2 Instance in default VPC

### **Step-02:**

### **Step-03:**

### **Step-04:**

### **Step-05:**

### References