# Pet Walk

## Description

- 강아지를 키우는 사람들에게 강아지와 산책하는 것에 동기를 부여하기 위한 앱
- 강아지만 즐거운게 아니라 강아지를 키우는 사람들도 강아지와 함께 산책하며 재미를 느낄 수 있도록 산책 장소를 정하고 실제로 산책을 다녀왔을 때 보상을 받는 등 재미 요소가 있어야겠다고 생각해서 개발

<p align="center">
	<img src="images/PetWalk-description.png" alt="Page Description" width="80%">
</p>

## Using Skills

- Swift, Firestore, MapKit, UIView Animation

## Architecture

- MVC Pattern을 적용하려고 시도했지만, app 크기가 커지면서 여러 개의 MVC 모듈을 적절하게 결합하지 못하고 각 part에 맞게 비지니스 로직을 분리하지 못함

- 기타 Delegate Pattern 및 Singleton Pattern 사용

- `Cloud Firestore`, `Cloud Storage`를 사용한 반려동물 정보 및 산책 기록 데이터 관리

  ```json
  {
    "Pets": [
      {
        "name": "mesh",
        "breed": "welshcorgi",
        "birth": "2020-01-01",
        "gender": "M",
        "profileURL": "{imageURL}",
        "weight": 10,	// kg
        "walks": [
          {
            "date": "",
            "duration": 3209,	// sec
            "weather": "",
            "dust": "",
            "images": [
              "{imageURL}",
              "{imageURL}",
            ]
          },
        ]
      },
    ]
  }
  ```

## Trouble Shooting

- Database에 데이터를 저장하는 동안 예상치 못한 사용자 입력 때문에 메인 화면에서 잘못된 데이터를 받아오는 문제

  - Database와 통신하는 시간이 길어지면서 데이터를 저장하고 불러오는 작업이 끝나기 전에 사용자가 의도하지 않은 동작을 할 가능성이 있음. 의도하지 않은 사용자 입력을 막고 서버와 통신하고 있다는 것을 인식시키기 위해 별도의 로딩 화면(`LoadingViewController`)을 만들어서 해결

  - Database 관련 작업의 성공/실패 여부에 따라 다음에 수행할 추가 작업을 위한 `LoadingViewControllerInterface` 구현

    ```swift
    protocol LoadingViewControllerInterface {
      // Database 작업에 성공했을 때, 추가작업을 completion으로 처리
      func complete(completion: @escaping ()->())
      // Database 작업에 실패했을 때, 사용자 알림(alert)을 위한 message 전달
      func fail(message: String)
    }
    ```

- 산책한 기록을 볼 수 있는 화면에서 사용자가 비어있는 화면을 오랫동안 보고 있어야 하는 문제

  - Firebase storage에 저장된 이미지를 받아오는 요청에 대한 Firebase 서버의 응답시간이 지연되어 발생하는 문제

  - 산책 기록 화면이 처음 나타날 때 firebase에 이미지를 요청해서 받아온 결과를 별도로 **캐싱(caching)**해 두고, 이후 산책 화면이 나타날 때는 Firebase 서버에 이미지를 요청하지 않고 캐싱해 둔 이미지를 사용하도록 함

  - 최초로 이미지를 요청하거나 새로운 이미지가 update 되었을 때만 firebase 서버와 통신하도록 함

    ```swift
    // MARK: Data Caching
    
    // caching when register new pet
    var currentPets = [Pet]()             
    // caching when walk list appear at first or new walk info updated
    var walksForPet = [String: [Walk]]()  
    
    // MARK: Image Caching
    
    // caching when pet list appear at first
    var petProfileCache = [String: UIImage]()
    // caching when walk list appear at first or new alk info updated
    var walkImageCache = [String: [UIImage]]()
    ```

## What's New

- [iOS Date Handling 정리]() : WIP
- [Firebase: Cloud Firestore 정리]() : WIP
- [UIView Animation 정리]() : WIP
