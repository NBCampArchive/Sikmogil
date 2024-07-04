![header](https://capsule-render.vercel.app/api?type=waving&color=0:D8F0E3,100:9BB291&height=260&section=header&text=Sikmogil&fontColor=ffffff&fontSize=70&animation=fadeIn&fontAlignY=38&desc=MVV%20Architecture&fontAlign=75&descAlign=81&descAlignY=58)

# 🌳 식목일 (식단, 목표, 일일 운동량)
<div align="center">
<img src="https://github.com/NBCampArchive/Sikmogil/assets/129912074/58ad28f5-ceb9-428d-bed4-9cf8d2cd18b0" width=800>

<br/><br/>

[![appStore](https://user-images.githubusercontent.com/50910456/173174832-7d395623-ceb3-4796-b718-22e550af6934.svg)](https://apps.apple.com/kr/app/%EC%8B%9D%EB%AA%A9%EC%9D%BC/id6503870760)

![Generic badge](https://img.shields.io/badge/Version-1.0-critical?labelColor=%2523789BFD&color=%252353D9FF.svg)
[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2FNBCampArchive%2FSikmogil&count_bg=%23B39CD0&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false)](https://hits.seeyoufarm.com)

</div>
<br/>


## Table of Contents
1. [Description](#description)
2. [Main Stacks](#main-stacks)
3. [Requirements](#requirements)
4. [Main Feature](#main-feature)
5. [기술적 의사소통](#기술적-의사결정)
6. [Trouble Shooting](#trouble-shooting)
7. [Period](#period)
8. [Developer](#developer)
9. [Contact](#contact)



<br/>

## Description


```

깔끔한 라이프 사이클 기록 앱을 찾고 계셨나요?

식단, 운동, 다이어트를 꾸준히 진행할 수 있도록 식목일이 도와드릴게요 ✨

```

**식목일**은 **`(식)단`**, **`(목)표`**, **`(일)일 운동량`** 의 줄임말로

운동과 식단에 관심이 많은 현대인들을 위해 간편한 기능을 담은 어플입니다.  🍎🏋️‍♂️

식목일은 여러분이 식단과 운동을 꾸준히 기록하고 목표를 달성할 수 있도록 도와줍니다. 📈

</br>

## Main Stacks

**Environment**

<img src="https://img.shields.io/badge/-Xcode-147EFB?style=flat&logo=xcode&logoColor=white"/> <img src="https://img.shields.io/badge/-git-F05032?style=flat&logo=git&logoColor=white"/> <img src="https://img.shields.io/badge/-github-181717?style=flat&logo=github&logoColor=white"/>

**Language**

<img src="https://img.shields.io/badge/-swift-F05138?style=flat&logo=swift&logoColor=white"/> 

**Communication**

<img src="https://img.shields.io/badge/-slack-4A154B?style=flat&logo=slack&logoColor=white"/> <img src="https://img.shields.io/badge/-notion-000000?style=flat&logo=notion&logoColor=white"/>  <img src="https://img.shields.io/badge/-figma-609926?style=flat&logo=figma&logoColor=white"/>

</br>

**Architecture** - DI, MVVM

**Dependency Management Tool** - SPM

**Interface** - UIKit

**Networking** - Alamofire, GoogleCloudPlatform, RESTful API
  
**Design Patterns** - Singleton, Delegate, Observer

**Local Storage** - UserDefaults

**Layout Configuration** - SnapKit, Then

**Image Processing** - Kingfisher, Google Cloud Storage



</br>

## Requirements
- App requires iOS 15.0 or above

</br>

---

## Main Feature

</br>

## 기술적 의사결정


### 🌱 Architecture
<details><summary><b>MVVM 패턴</b></summary>
  
- **효율적인 데이터 바인딩**
   - 식단, 운동, 스케줄을 관리하는 어플리케이션 특성상 화면 간 데이터 전달이 빈번하게 발생합니다. 이를 효율적으로 처리하기 위해 MVVM 패턴을 도입하였습니다. 뷰모델과 컴바인을 사용한 데이터 바인딩으로 데이터 흐름을 간편하게 관리할 수 있습니다.
- **기술 역량 향상**
   - 팀원들이 기존에 MVC 패턴에 익숙했기 때문에, 새로운 아키텍처를 도입하여 개인의 기술 역량을 향상시키고자 하였습니다. MVVM 패턴을 통해 보다 구조적이고 유지보수가 용이한 코드를 작성할 수 있게 되었습니다.
</details>
   
<details><summary><b>컴바인 데이터 바인딩</b></summary>

- **신뢰성 및 호환성**
   - 컴바인은 애플에서 직접 개발한 프레임워크로, 향후 지원과 호환성 측면에서 신뢰할 수 있습니다.
- **학습 용이성**
   - RXSwift에 비해 학습 곡선이 완만하여, MVVM을 처음 접하는 팀원들도 쉽게 적용할 수 있었습니다. 이를 통해 개발 속도를 높이고 코드의 일관성을 유지할 수 있었습니다.
 </details>
 
</br>

 ### 🌱 Networking
<details><summary><b>백앤드 서버 연결</b></summary>

- **자체 데이터베이스 설계**
   - 파이어베이스 대신 자체적으로 설계한 데이터베이스를 서버에서 운영하고 있습니다. 사진 앨범, 캘린더 기록등 앱을 사용하는 기간이 길어질 수록 저장되는 데이터의 증가로 내부 저장소 사용시에 앱 크기가 증가하는 현상을 방지할 수 있었습니다.
 </details>


</br>

 ### 🌱 Data Storage
 <details><summary><b>UserDefaults</b></summary>
  
- 알림 시간, 타이머 시작 시간 등 서버에 저장하기엔 단기간 저장되는 데이터를 보관하기 위해 사용하였습니다.
 </details>
 
 <details><summary><b>KeychainSwift</b></summary>
  
- JWT token 을 안전하게 저장하기 위해 사용하였습니다.
 </details>
 
</br>

 ### 🌱 UI / Asset Management

<details><summary><b>UI 구성</b></summary>

- **Snapkit 및 Then 라이브러리 도입**
   - 코드를 간결하게 구성하고 유지보수를 용이하게 하기 위해 스냅킷과 댄 라이브러리를 도입하였습니다. 이를 통해 UI 레이아웃 작업을 효율적으로 처리할 수 있었습니다.
 </details>
 
<details><summary><b>Asset</b></summary>

- **SVG 파일 사용**
   - 이미지 확장자를 SVG 파일로 통일하여 Asset 저장소 용량을 관리하였습니다. 이는 앱의 성능 최적화와 용량 관리를 효과적으로 할 수 있게 해줍니다.
- **공통 자원 관리**
   - 컬러, 폰트, 아이콘 등 앱 전반에 공통적으로 사용되는 파일을 Asset으로 관리하여, 일관된 디자인과 효율적인 자원 관리를 실현하였습니다
 </details>


</br>


## Trouble Shooting

- [**2.1.0 Performance: App Completeness**](https://github.com/NBCampArchive/Sikmogil/wiki/Trouble-Shooting#210-performance-app-completeness)
- [**UITabBarController 설정 문제**](https://github.com/NBCampArchive/Sikmogil/wiki/Trouble-Shooting#uitabbarcontroller-%EC%84%A4%EC%A0%95-%EB%AC%B8%EC%A0%9C)
- [**한번에 여러 화면 이동**](https://github.com/NBCampArchive/Sikmogil/wiki/Trouble-Shooting#%ED%95%9C%EB%B2%88%EC%97%90--%EC%97%AC%EB%9F%AC-%ED%99%94%EB%A9%B4-%EC%9D%B4%EB%8F%99)
- [**페이징 처리를 통한 데이터 로드**](https://github.com/NBCampArchive/Sikmogil/wiki/Trouble-Shooting#%ED%8E%98%EC%9D%B4%EC%A7%95-%EC%B2%98%EB%A6%AC%EB%A5%BC-%ED%86%B5%ED%95%9C-%EB%8D%B0%EC%9D%B4%ED%84%B0-%EB%A1%9C%EB%93%9C)
- [**네트워크 요청과 UI업데이트 싱크**](https://github.com/NBCampArchive/Sikmogil/wiki/Trouble-Shooting#%EB%84%A4%ED%8A%B8%EC%9B%8C%ED%81%AC-%EC%9A%94%EC%B2%AD%EA%B3%BC-ui%EC%97%85%EB%8D%B0%EC%9D%B4%ED%8A%B8-%EC%8B%B1%ED%81%AC)


</br>

## Period
- 개발 기간 : 2024.05.28 - 2024.07.04.
- version 1.0 : 앱 스토어 배포 (24.07.01)
- version 1.1 : 기록을 확인 할 수 있는 캘린더 구현, 식단, 운동 등 앨범 구현 (24.07.06)

</br>

## Developer
|<img src="https://avatars.githubusercontent.com/u/112539563?v=4" width="100" height="100"/>|<img src="https://avatars.githubusercontent.com/u/129912074?v=4" width="100" height="100"/>|<img src="https://avatars.githubusercontent.com/u/112465877?v=4" width="100" height="100"/>|<img src="https://avatars.githubusercontent.com/u/161270633?v=4" width="100" height="100"/>|
|:-:|:-:|:-:|:-:|
|박현렬<br/>[@devpark435](https://github.com/devpark435)|정유진<br/>[@yyujnn](https://github.com/yyujnn)|박준영<br/>[@Neo-agnes](https://github.com/Neo-agnes)|조희라<br/>[@Heather-Cho](https://github.com/Heather-Cho)|


 *  **박현렬** 
    - 회원 가입, 온보딩
    - 커스텀 캘린더, 하루 일기
    - API 요청 코드 제작, 관리
    - 커스텀 프로그레스 바 제작
    
 *  **정유진** 
    - 운동 API 모델 생성
    - 운동 추가 및 관리 구현
    - 운동 타이머 구현
    - 애플 건강 걸음 수 연동
    
 *  **박준영** 
    - 회원정보 표시 구현
    - 회원정보 수정 구현
    - 알림기능 구현
     
 *  **조희라** 
    - 식단데이터 API 모델생성
    - 식단관리 구현
    - 물마시기 구현
    - 공복타이머 구현
     
</br>

## Contact
- [Email](mailto:sikmogilhealthcare@gmail.com): 문의 및 건의사항, 피드백 전달
- [Introduction URL](https://available-account-9be.notion.site/Sikmogil-4f6eb027ee0a4f8ba785dd2b9b5e9cc2): Sikmogil 지원 URL

