# Terraform & AWS CLI 설치

소유자: 익명
최종 편집 일시: 2023년 4월 12일 오후 12:50
태그: AWS, Terraform

## **Terraform & AWS CLI 설치**

### **Step-01: 소개**

- Terraform CLI 설치
- AWS CLI 설치
- VSCode 설치
- HashiCorp Terraform plugin for VSCode 설치

### **Step-02: MACOS: Terraform 설치**

- 🔗 [Terraform MAC 설치](https://developer.hashicorp.com/terraform/downloads) (Homebrew)
    
    ```bash
    brew tap hashicorp/tap
    brew install hashicorp/tap/terraform
    ```
    
    ![Untitled](Terraform%20&%20AWS%20CLI%20%E1%84%89%E1%85%A5%E1%86%AF%E1%84%8E%E1%85%B5%2030ec176c917340818445dda4caffcdeb/Untitled.png)
    

### **Step-03: MACOS: IDE for Terraform - VS Code Editor**

- 🔗 [VSCode 설치](https://code.visualstudio.com/download)
- 🔗 [HashiCorp Terraform Plugin for VS Code 설치](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform)

VSCode 확장프로그램인 HashiCorp Terraform을 설치합니다.
    
    ![Untitled](Terraform%20&%20AWS%20CLI%20%E1%84%89%E1%85%A5%E1%86%AF%E1%84%8E%E1%85%B5%2030ec176c917340818445dda4caffcdeb/Untitled%201.png)
    
    ![Untitled](Terraform%20&%20AWS%20CLI%20%E1%84%89%E1%85%A5%E1%86%AF%E1%84%8E%E1%85%B5%2030ec176c917340818445dda4caffcdeb/Untitled%202.png)
    
    ![Untitled](Terraform%20&%20AWS%20CLI%20%E1%84%89%E1%85%A5%E1%86%AF%E1%84%8E%E1%85%B5%2030ec176c917340818445dda4caffcdeb/Untitled%203.png)
    
    ![Untitled](Terraform%20&%20AWS%20CLI%20%E1%84%89%E1%85%A5%E1%86%AF%E1%84%8E%E1%85%B5%2030ec176c917340818445dda4caffcdeb/Untitled%204.png)
    

### **Step-04: MACOS: AWS CLI 설치**

- 🔗 [AWS CLI 설치](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

```bash
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg ./AWSCLIV2.pkg -target /

which aws
/usr/local/bin/aws
aws --version
aws-cli/2.10.0 Python/3.11.2 Darwin/18.7.0 botocore/2.4.5
```

![Untitled](Terraform%20&%20AWS%20CLI%20%E1%84%89%E1%85%A5%E1%86%AF%E1%84%8E%E1%85%B5%2030ec176c917340818445dda4caffcdeb/Untitled%205.png)

### **Step-05: MACOS: AWS Credentials 설정**

- 전제조건
    - 🔗 [AWS 계정이 필요합니다.](https://portal.aws.amazon.com/billing/signup/iam?nc2=h_ct&redirect_url=https%3A%2F%2Faws.amazon.com%2Fregistration-confirmation&src=header_signup#/account)
- AWS Management Console에 접근하여 보안 자격을 생성합니다.
    - Services → IAM → Users → "Admin-User" → Security Credentials → Create Access Key
- 로컬에서 SSH 터미널을 열어 AWS 자격증명을 구성합니다
    
    ```bash
    aws configure
    AWS Access Key ID [None]: {Your Access Key ID}
    AWS Secret Access Key [None]: {Your Secret Access Key}
    Default region name [None]: {Your Default region : ap-northeast-2(KOR)}
    Default output format [None]:
    ```
    
- S3 버킷에 접근 가능한지 확인해봅니다
    
    ```bash
    aws s3 ls
    ```
    
    ![Untitled](Terraform%20&%20AWS%20CLI%20%E1%84%89%E1%85%A5%E1%86%AF%E1%84%8E%E1%85%B5%2030ec176c917340818445dda4caffcdeb/Untitled%206.png)
    
- AWS 자격 증명 프로필을 확인합니다
    
    ```bash
    cat $HOME/.aws/credentials
    ```
    
    ![Untitled](Terraform%20&%20AWS%20CLI%20%E1%84%89%E1%85%A5%E1%86%AF%E1%84%8E%E1%85%B5%2030ec176c917340818445dda4caffcdeb/Untitled%207.png)
    

### **Step-06: Other OS: Terraform 및 AWS CLI 설치**

- Windows
    - 🔗 [테라폼 다운로드](https://www.terraform.io/downloads.html)
    - 🔗 [CLI 설치](https://learn.hashicorp.com/tutorials/terraform/install-cli)
    - 패키지 압축 해제
    - 새 폴더 만들기`terraform-bins`
    - `terraform.exeterraform-bins`에 복사
    - Windows에서 PATH 설정
    - 🔗 [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) 설치
- Linux
    - 🔗 [테라폼 다운로드](https://www.terraform.io/downloads.html)
    - 🔗 [Linux OS - Terraform 설치](https://learn.hashicorp.com/tutorials/terraform/install-cli)

### References

[Install | Terraform | HashiCorp Developer](https://developer.hashicorp.com/terraform/downloads)

[](https://code.visualstudio.com/download)