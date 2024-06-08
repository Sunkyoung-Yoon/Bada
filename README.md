# 바래다줄게 (BADA) - 부모를 위한 아이 안전 등굣길 추천 및 알림 서비스
<img src="https://github.com/Sunkyoung-Yoon/SunKyoung-Yoon/assets/97610532/020f291a-8a41-42fd-a22a-7f99e3a7413c" width="700px" height="500px">

<br>

# 💡서비스 소개

어린 자녀들이 안전하게 등교하고 있는 지, 걱정되지는 않으신가요?

아이들이 안전한 등굣길로 가길 바란다면!

잘 가고 있는 지 걱정된다면!

도착은 언제 했는지 궁금하다면!

초등학교 저학년들을 위한 안전 등굣길 안내와 알림 서비스를 제공하는 바래다줄게를 써보세요!

<br>

# ⏱️ 프로젝트 진행 기간

### 2024.02.19 ~ 2024.04.04 (7주)

### SSAFY 10기 2학기 특화프로젝트

<br>

# ⭐ 기획 배경

초등학교 저학년을 위한 등굣길은 항상 안전할까요? 맞벌이 부부가 늘어나면서 아이는 보호자 없이 혼자 혹은 아이들끼리 등교하는 경우가 대다수입니다.

아이들이 실종되었을 때, 3시간 이후로 기점으로 발견 건수는 급락한다고 합니다.

아이가 연락이 안되었던 지점을 바로 안다면? 그 근처 cctv 위치도 바로 알고 있다면? 빠른 속도로 찾을 수 있게 될 것입니다.

그래서 cctv를 중심으로 경찰청, 아동안전지킴이집 위치를 고려한 안전 경로를 제공해주는 바래다줄게를 기획하게 되었습니다.

바래다줄게는 아이와 부모 앱으로 구분되어 아이는 부모가 지정해준 목적지 중 하나를 도착치로 하여 아이가 출발을 누른다면 그때부터 부모님들은 아이의 실시간 위치를 볼 수 있으며, 아이의 출발,도착, 경로이탈에 대한 알림 정보를 받을 수 있습니다.

<br>

# 활용한 데이터셋

|LocalData(https://www.localdata.go.kr)|공공데이터포털(https://www.data.go.kr/)|스마트치안 빅데이터 플랫폼(https://www.bigdata-policing.kr/)|
|:--:|:--:|:--:|
|<img src="https://github.com/Sunkyoung-Yoon/SunKyoung-Yoon/assets/97610532/021e1f81-45ac-4db0-af14-6962a2350687" width="800px">|<img src="https://github.com/Sunkyoung-Yoon/SunKyoung-Yoon/assets/97610532/8900d209-acac-47be-9fb1-ca27b6f5fc8c" width="800px">|<img src="https://github.com/Sunkyoung-Yoon/SunKyoung-Yoon/assets/97610532/89c1c459-9b1f-4a78-9e92-fd1c0052ff7f" width="800px">  |
<br>
<br>

# 🛠️ 기술 스택

### Frontend

- flutter 3.19.3
- shared_preferences
- flutter_secure_storage
- provider
- geolocator
- firebase_messaging

### Backend

- IntelliJ : 2023.03.04
- Java : 17.0.10
- Springboot : 3.1.9
- Spring Security
- Spring Data JPA
- Gradle 8.5
- Junit5
- h3 4.1.1

### Database

- MySQL 8.0.36
- AWS S3

### Infra

- Ubuntu 20.04 LTS
- Nginx 1.18.0(Ubuntu)
- Docker 25.0.4
- Docker Compose 2.24.7
- Jenkins
- Kafka 3.4.1
- Apache Zookeeper

<br>

# 주요 기능

1. **로그인/회원가입**
    - 소셜 로그인으로 회원가입 진행 (네이버, 카카오)
        - 필요한 정보가 소셜 로그인으로 충족 가능했고, 접근성을 높이기 위해 소셜로그인으로 회원가입 진행
    - 새로운 가족 그룹 생성 또는 기존 그룹 가입으로 가입 진행
        - 새로운 가족 그룹 : 새로운 패밀리 생성
        - 기존 가족 그룹 가입 : 인증 코드를 통해 해당 회원을 그 패밀리에 등록
2. **우리 가족**
    - 아이들의 알림 기록들을 볼 수 있으며, 프로필 수정이 가능합니다.
    - 이동 중인 아이가 있다면 아이의 실시간 위치를 확인할 수 있습니다.
3. **내 장소**
    - 부모 측에서 등록하는 아이의 도착지 목록
    - 아이 측은 현재 위치를 출발지로, 부모가 등록한 도착지 목록 중에 하나를 도착지로 설정 가능합니다.
4. **안전 경로 추천** 
    - 출발지와 도착지를 입력하면 cctv, 경찰서, 아동안전 지킴이집을 고려, cctv를 거쳐가도록 하는 경로를 제공
    - 추천 알고리즘
        - 처음 설계는 a* 알고리즘을 활용해서 헥사곤을 선택하면서 진행하는 방식을 고려
            
            → 실제 cctv 분포를 보니 빈 헥사곤을 선택하는 과정이 많고, cctv 점수가 부여된 헥사곤 위주로 선택하려고 하니 a* 알고리즘을 무의미 해짐 (도보로 하는 등굣길을 기준으로 하고 있기 때문)

        |1. 폴리라인 범위 안 헥사곤 리스트 수집|
        |:--|
        |<img src="https://github.com/Sunkyoung-Yoon/SunKyoung-Yoon/assets/97610532/00cd527a-6176-426c-b489-a6a17480f586" width="650px" height="400px" >|
        |2. 탐색 범위 헥사곤 가중치 부여|
        | - cctv, 경찰청, 아동안전지킴이집의 좌표를 각각 헥사곤으로 변환해서 그 헥사곤에 각각 가중치 부여<br> <img src="https://github.com/Sunkyoung-Yoon/SunKyoung-Yoon/assets/97610532/7fbcb2b6-ade5-423a-847e-876f66895a75" width="650px" height="400px" >|
        |3. 레이어별 헥사곤 선택|
        |<img src="https://github.com/Sunkyoung-Yoon/SunKyoung-Yoon/assets/97610532/2a2b9343-8edf-4ddf-beb2-0e64074e8379" width="650px" height="400px">|

        > #### ❓ 왜 5개의 레이어를 두나요?
        |<img src="https://github.com/Sunkyoung-Yoon/SunKyoung-Yoon/assets/97610532/5bb66401-2d30-492c-bfa7-6848f1c10b41" width="550px" height="320px">|
         
        > #### ❓ 등굣길로 너무 먼 거리라면?
        |<img src="https://github.com/Sunkyoung-Yoon/SunKyoung-Yoon/assets/97610532/6a24af5a-82a1-4564-a976-380eec81504b" width="550px" height="300px">|<img src="https://github.com/Sunkyoung-Yoon/SunKyoung-Yoon/assets/97610532/a909ca70-5f0d-4553-9ec3-ac9d97a664da" width="550px" height="200px">|<img src="https://github.com/Sunkyoung-Yoon/SunKyoung-Yoon/assets/97610532/1540a5b1-edf3-4e9d-b632-91c0087eee0e" width="550px" height="300px">|
        |:--|:--|:--|

        |4. 선택된 헥사곤을 경유지로 경로 반환|
        |:--|
        |<img src="https://github.com/Sunkyoung-Yoon/SunKyoung-Yoon/assets/97610532/c22c7460-4356-4658-853b-9a68493ec17d" width="650px" height="400px">|
                    
                    
5. **알림**
 - 아이 폰의 GPS를 기준으로 출발, 도착, 안전 경로에 대한 경로 이탈 알림 부모에게 전송
 - 알림 전송 아키텍처

    |<img src="https://github.com/Sunkyoung-Yoon/SunKyoung-Yoon/assets/97610532/ab26c51c-f92d-4af1-940b-c7498d33c752" width="550px" height="300px">|<img src="https://github.com/Sunkyoung-Yoon/SunKyoung-Yoon/assets/97610532/ad20c203-bc01-4f01-8a41-5fcc7109e4b3" width="550px" height="250px" >|
    |:--|:--|
    
    

### 아이 위치 좌표가 실시간으로 백엔드로 전달 
    - 아이의 위치 정보와 타입에 따른 분기 처리
    - 좌표를 기준으로 경로 범위 이탈 여부 감지
        - 출발지와 도착지 경로의 원형 형태로 범위를 생성하여 좌표의 값이 범위를 이탈하는 경우에 알림 작성되도록 구현
    - 범위 이탈 판정 시, Producer로 데이터 생성하여 kafka로 알림 topic으로 데이터 전송
        - Kafka를 도입하여 이전의 획일화된 알람 생성과 전송 로직을 분리,
        - Producer 로 알림 전송할 데이터를 kafka broker로 넘겨서 리스펀스가 각자 리턴할 수 있게 구현
    - Kafka consumer는 알림 topic으로 들어온 메시지를 감지하여 처리
        - 들어온 알림 데이터를 FCM 템플릿에 맞게 작성
    - 아이가 속한 패밀리 코드를 기준으로 부모 정보 확보
        - DB 조회로 패밀리코드와 일치하는 모든 부모 리스트 확보
    - 해당 부모들에게 알림 데이터를 FCM  푸시 알림으로 전송
        - Firebase Cloud 로 전송하여 푸시알림을 각 기기로 전송
    - 부모 모바일 앱 : 푸시알림 (포그라운드, 백그라운드, 앱 종료 상태) 수신

<br>

# 협업 툴

- Git
- Jira
- Notion
- Figma
- ERDcloud
- Discord

<br>

# 협업 환경

- Gitlab
    - 코드 버전 관리
    - 기능별, 이슈별 브랜치를 생성해서 진행
- JIRA
    - 매주 월요일 오전 목표량을 정해 스프린트 진행
    - 이슈 별 해야하는 업무를 자세히 작성하고, Story Point와 Epic을 설정하여 작업
- 데일리 스크럼
    - 매주 오전 데일리 스크럼을 진행하여 서로 간의 진행 상황 공유 및 그날 진행할 업무 브리핑
    - 매일 소통하면서 새로 생기는 이슈에 빠른 대응 가능해짐
- Notion
    - 회고록 및 회의록이 있을 때마다 매번 기록하여 보관
    - 참고할 기술, 자료 확보 시 모두가 볼 수 있도록 공유
    - 컨벤션 정리 (git, gerrit 등)
    - 문서 정리 (요구사항 명세서, ERD 명세서, API 명세서)
    - develop-all에 merge되는 브랜치 정리해서 공유
    - 백엔드, 프론트엔드 각각 페이지를 구성해서 실행 과정 정리, secret.yml 파일 등 공유
- Gerrit
    - 각 브랜치에 리뷰오픈으로 push하여 리뷰에서 통과못하면 merge 못하도록 방지
    - dto에 필요한 추가 변수, 테스트코드 오류, css 깨짐, typescript 오류 부분 등 확인하며 코드 리뷰 진행
    - 코드 리뷰가 모두 완료된 브랜치가 생기면 프론트엔드,백엔드 각 지정한 1명이 dev-front, develop-back 브랜치에 merge 진행

<br>

# 시스템 아키텍처
<img src="https://github.com/Sunkyoung-Yoon/SunKyoung-Yoon/assets/97610532/87313244-8403-4b44-80ba-5cb6b6d3c7af" width="700px" height="400px"><br>


<br>

# ERD
<img src="https://github.com/Sunkyoung-Yoon/SunKyoung-Yoon/assets/97610532/c64b8c07-9f2a-4c6b-9709-5cbeac78bcc0" width="700px" height="400px"><br>


<br>
<br>

# 팀 구성

| 이름 | 역할 |
| --- | --- |
| 윤선경 (팀장) | - BackEnd<br> - 전역예외 처리 및 테스트 코드 틀 구성 및 작성<br> - Spring security, JWT, 회원가입 구현 (인증, 인가), 인증 코드 기반으로 기존 가족 그룹 가입 구현<br> - 회원, 내 장소, 우리 가족, 아이 현재 위치 관련 crud 구현<br>  - AWS S3를 활용한 파일 업로드 기능 구현<br> - h3 헥사곤 관련 메서드 구현 및 안전 경로 추천 알고리즘 설계<br> - ssl 인증<br> - Nginx 백엔드 분기 처리 (/api) |
| 심지연 | - BackEnd<br> - 상태 및 경로 저장, 조회, 삭제 구현<br> - tmap api response를 json parsing으로 데이터 처리<br> - h3를 이용한 cctv 위주의 안전 경로 추천 알고리즘 설계<br> - 이동거리에 따른 layer 조절<br> - docker를 이용한 jenkins 자동 배포 구현 |
| 이용준 | - BackEnd<br> - 아이 경로 이탈 알림 구현<br> - Kafka의 서비스 분산 큐잉 시스템 활용 백그라운드 프로세서로 분리<br> - 알림 전송 API : 전송 처리 성능 개선<br> - 알림 로그 조회 및 기록 구현<br> - FCM push notification 푸시알림 구현<br> - Docker compose 활용 Kafka 이미지 설정 |
| 정휘원 | - FrontEnd<br> - 부모 앱 전반 디자인 및 구조 설계(기초 CSS)<br> - 페이지 간 이동 및 앱 구동 시 로딩-로그인-홈 화면 로직 설계<br> - 우리 가족, 알림, 내 장소, 설명서, 설정 페이지 생성 및 api 연결<br> - Flutter Secure Storage를 사용한 토큰 관리(FE 공통)<br> - 동기/비동기 데이터 흐름 토의 |
| 이창헌 | - FrontEnd<br> - 아이 앱 전반 구조 설계 및 디자인<br> - lottie를 이용한 animation 사용과 animationController를 통한 생명주기 관리<br> - 소셜 로그인 API 연결 및 백엔드 Access토큰 처리<br> - 지도 관련 API 연결 및 비동기 처리<br> - 프로필 수정 등 S3에 파일 저장을 위한 http multipart 통신 구현<br> - 각 상황에 따라 FlutterSecureStorage, SharedPreferences, DB 중에 적절한 저장소 선택<br> - flutter 파일 구조 개선 |

<br>

# 프로젝트 산출물

- [요구사항 명세서](https://www.notion.so/4228f33ed79e46b090542d90b5cb794e?pvs=21)
- [디자인 (피그마)](https://www.figma.com/file/RINWp27EYDANaC5oPhM967/%EC%99%80%EC%9D%B4%EC%96%B4%ED%94%84%EB%A0%88%EC%9E%84---%EC%8B%A4%ED%96%89?type=design&node-id=0-1&mode=design&t=K1ECvWPS9QAL61dJ-0)
- [API 명세서](https://www.notion.so/API-2024-03-29-12-39-f28b33f1067d41d1a21d0abf5432af0e?pvs=21)
- [컨벤션](https://www.notion.so/5b00a94d8bc84c75b92837f8e7c13dcf?pvs=21)

<br>



# 바래다줄게 실행화면 (부모)
- 회원가입 및 로그인
  - 새로운 가족 생성
  - 기존 가족 그룹 가입

    <img src="https://github.com/Sunkyoung-Yoon/SunKyoung-Yoon/assets/97610532/ea8b5768-34e1-420c-877a-055a9827fcbc" width="300px" height="600px">
- 알림
  - 메인 -> 알링에서 모든 알림 확인 가능 (메인에서 안 읽은 알림 개수 표시)
  - 아이 상황에 대한 알림 제공
    |경로 이탈|장시간 정지|고속이동|
    |---|---|---|
    |<img src="https://github.com/Sunkyoung-Yoon/SunKyoung-Yoon/assets/97610532/a37d57f8-095a-464c-aef0-2f7377dfed3d" width="300px" height="600px">|<img src="https://github.com/Sunkyoung-Yoon/SunKyoung-Yoon/assets/97610532/f126d263-660b-48fc-a398-91b41f2203e6" width="300px" height="600px">|<img src="https://github.com/Sunkyoung-Yoon/SunKyoung-Yoon/assets/97610532/20b1e673-b497-4591-b489-fe4efa69a79a" width="300px" height="600px">|

- 우리 가족
  - 아이의 알림 기록 확인 및 프로필 수정
  - 이동 중인 아이가 있다면 아이의 실시간 위치 확인 가능

    <img src="https://github.com/Sunkyoung-Yoon/SunKyoung-Yoon/assets/97610532/90707fec-4d08-423c-aa51-c1214db0bdd2" width="300px" height="600px">
- 내 장소
  - 아이의 도착지 등록

    ![내장소목록](https://github.com/Sunkyoung-Yoon/SunKyoung-Yoon/assets/97610532/3c873797-f277-4318-af7b-92ed05ebaffb)
- 경로 검색
  - 출발지와 도착지 기반으로 추천되는 안전 경로 확인

   <img src="https://github.com/Sunkyoung-Yoon/SunKyoung-Yoon/assets/97610532/4dc10eaa-51af-4df1-a912-316d6329c262" width="300px" height="600px">

<br>

# 다녀올게요 실행화면
- 회원가입 및 로그인
    - 부모 앱 인증번호를 이용해 회원가입 진행

    <img src="https://github.com/Sunkyoung-Yoon/SunKyoung-Yoon/assets/97610532/847989c3-23db-4720-861e-510863046ca4" width="300px" height="600px">

- 출발하기 
  - 내 장소 목록(부모가 지정한 목록) 중 하나를 선택하면 출발
  - 도착을 누르기 전 까지는 출발하기에 다시 들어가도 출발한 경로를 계속 보여줌

    <img src="https://github.com/Sunkyoung-Yoon/SunKyoung-Yoon/assets/97610532/be09e881-cccd-4729-805c-b761eeb7f647" width="300px" height="600px">
- 전화하기
  - 등록된 우리 가족에게 전화걸기 가능 


<br>
<br>
