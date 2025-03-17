# HiKi (나만의 애니 저장소)


## 📌 프로젝트 개요
HiKi (나만의 애니 저장소)는 Open API를 활용하여 다양한 애니 정보를 제공하는 iOS
애플리케이션입니다. 사용자는 애니의 포스터, 시놉시스, 캐스트, 장르, 평점, 티저 등의 정
보를 확인하고, 좋아요 기능을 통해 선호하는 애니메이션을 저장 및 관리할 수 있습니다

<img width="566" alt="스크린샷 2025-03-17 오후 2 11 02" src="https://github.com/user-attachments/assets/2c17cf3a-e112-4cae-9fe3-85518b470724" />


## 📅 프로젝트 기간
- **2025.01.24 ~ 2025.3.16**

## 👨‍💻 개발자
- **1인 개발**

## 🎬 주요 기능
### 1. 사용자 프로필 설정
- 사용자 프로필 이미지, 닉네임 설정

### 2. 시네마 화면
- 방영, 최신인기, 즐겨보는, 연령별, 상영예정작에 대한 정보 제공
- TV, Original(OTT), 평점 등의 정보 제공

### 3. 검색 화면
- 애니 검색 기능 제공
- 검색 결과 페이징 기능 지원

### 4. 나만의 리뷰
- 애니메이션 상세페이지에서 나만의 리뷰 작성
-  애니메이션 주인공의 말투로 나만의 리뷰에 대한 답변 생성 기능

### 5. 모두의 리뷰
- 다른사람들이 남긴 랜덤 리뷰 제공

### 6. 프로필 설정
- 개인 프로필 설정

## 🛠 기술 스택
- **UIKit**
- **RxSwift(Cocoa)**
- **MVVM 아키텍처 + Router Pattern**
- **Alamofire** (네트워크 통신)
- **SnapKit** (AutoLayout)
- **Kingfisher** (이미지 로딩 및 캐싱)

## ⚙️ 기술 구현 설명
- **UserDefaults 싱글톤 패턴**을 활용하여 사용자 정보, 좋아요 목록, 최근 검색어 등을 관리
  - 내부 코드를 **연산 프로퍼티(get, set) 및 제네릭 타입**을 활용하여 간결하게 구현
  - PropertyWrapper를 활용해 반복되는 연산 최적화
 
- **고화질 애니 포스터 이미지 최적화**
  - Kingfisher의 `setImage` 사용 시, **UIImage Extension**을 활용하여 **ImageIO 기반의 다운 샘플링**을 직접 구현하여 대용량 이미지 로딩 성능 최적화


## 🛠 트러블슈팅
- **서버 응답 데이터가 없는 경우**
  - 이미지 또는 영화 정보가 없을 때 기본 텍스트를 표시하여 사용자 경험 개선
- **네트워크 오류 처리**
  - 서버와의 통신 오류 발생 시, 오류 페이지를 `present`하도록 구현
  - 상태 코드별로 다른 오류 메시지를 표시하여 사용자에게 명확한 피드백 제공
    
- **MLKit**
  - 해외 API로 영어를 한국어로 번역이 필요해 외부 통신 없이 'GoogleMLKit/Translate'을 import하여 내부에서 사용 -> SPM에 대응되지 않는 문제 -> CocoaPods으로 대응
  - CocoaPods 설치 후 `could not find module for target 'x86_64-apple-ios-simulator' found arm64 arm64-apple-ios-simulator` 에러 발생.
  ### 원인
   M1 이후 애플의 ARM 기반의 맥을 지원하게 되며 아이폰 시뮬레이터에 ARM용 아키텍쳐 arm64추가로 위의 문제 발생. 과거의 맥인 경우 대부분의 맥은 인텔 CPU를 탑재하고 있고, x86_64 아키텍쳐를 사용.
  ### 해결(추가 조사 필요)
  1. Build Setting -> Debug, Release(Yes) 설정 변경
  2. podfile에 코드 추가
     `post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
    end
  end
end
`


