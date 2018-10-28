> 지속해서 업데이트할 예정입니다.

ARKit를 공부하며 이해한 것을 바탕으로 기록해보았습니다. 완벽히 이해를 하지 못한 부분은 이에 대한 언급을 하였습니다. 

다음은 공부를 하면서 참고한 영상 및 레퍼런스입니다. 

*Apple Official References about ARKit*

- [Introducing ARKit: Augmented Reality for iOS - WWDC 2017](https://developer.apple.com/videos/play/wwdc2017/602)
- [Understanding ARKit Tracking and Detection - WWDC 2018](https://developer.apple.com/videos/play/wwdc2018/610/)

*Other References about ARKit*

- 추후 업데이트 예정

*Code Implementation*

- [Class References and Implementation using SceneKit](https://ehdrjsdlzzzz.github.io/2018/10/13/ARKit-Reference-1/)
- [Detecting Plane and Placing Object](https://ehdrjsdlzzzz.github.io/2018/10/28/ARKit-Reference-2/)

---

### [Introducing ARKit: Augmented Reality for iOS - WWDC 2017](https://developer.apple.com/videos/play/wwdc2017/602)

### Getting Started

ARKit는 AR에 필요한 프로세스 작업을 맡고 오브젝트를 랜더링은 `SceneKit`, `SpriteKit` 그리고 `Metal`이 맡는다.

<img src="./images/1.png">

그리고 AR 프로세스 작업에는 내부적으로 `AVFoundation`과 `Core Motion`을 사용한다.

- `AVFoundation` - 카메라 영상으로부터 들어오는 데이터 제공
- `Core Motion` - 디바이스의 모션 데이터를 제공

ARKit에서 AR 작업을 위한 주요 프로세스는 `ARSession`이 담당한다.

#### [`ARSession`](https://developer.apple.com/documentation/arkit/arsession)

공유 객체로 증강 현실 경혐 구축에 필요한 디바이스 카메라와 모션 처리를 관리.

`ARSession` 객체는 증강 현실 경험을 만들기 위해 ARKit가 수행하는 주요 프로세스를 조정한다. 이 프로세스에는 디바이스 모션 감지 하드웨어로부터 데이터 읽기, 디바이스에 내장된 카메라 조정 그리고 캡쳐된 카메라 이미지들로부터의 이미지 분석 수행이 포함된다. 세션은 이러한 작업들의 결과를 통합하여 장치가 실제 존재하는 공간과 AR 컨텐츠를 모델링하는 가상 공간 사이의 연결을 구축한다. 

그리고 이 세션은 원하는 필요로하는 기능에 따른 `ARConfiguration` 서브 클래스를 필요로 한다.

#### [`ARConfiguration`](https://developer.apple.com/documentation/arkit/arconfiguration)

AR 세션 구성을 위한 추상 클래스로 이 클래스의 인스턴스를 직접 만들거나 작업해선 안된다. 

AR 세션을 실행시키기 위해선 당신이 제작하는 앱이나 게임에서 필요한 AR 경험 종류에 따라 알맞는 [`ARConfiguration`](https://developer.apple.com/documentation/arkit/arconfiguration)의 서브클래스들의 인스턴스를 생성해서 사용해야 한다. 그리고 구성 객체의 프로퍼티를 지정하고 이를 세션의 [`run(_:options:)`](https://developer.apple.com/documentation/arkit/arsession/2875735-run) 메소드에 전달한다. ARKit는 다음과 같은 구성 클래스들을 포함하고 있다.

- [`ARWorldTrackingConfiguration`](https://developer.apple.com/documentation/arkit/arworldtrackingconfiguration) 
  - 후면 카메라를 활용해 디바이스의 위치와 방향을 정교하게 추격하고 지면 감지, 히트 테스팅, 환경에 기반한 조명, 이미지와 사물 인식이 가능한 상위 수준의 AR 경험을 제공
- [`AROrientationTrackingConfiguration`](https://developer.apple.com/documentation/arkit/arorientationtrackingconfiguration)
  - 후면 카메라를 활용해 디바이스의 방향만을 추적하는 기본적인 AR 경험을 제공
- [`ARImageTrackingConfiguration`](https://developer.apple.com/documentation/arkit/arimagetrackingconfiguration)
  - 후면 카메를 활용해 사용자 환경에 상관없이 가시적인 이미지들을 추적하는 기본적인 AR 경험을 제공
- [`ARFaceTrackingConfiguration`](https://developer.apple.com/documentation/arkit/arfacetrackingconfiguration)
  - 전면 카메라를 활용해 사용자 얼굴의 움직임과 감정을 추적하는 AR 경험을 제공
- [`ARObjectScanningConfiguration`](https://developer.apple.com/documentation/arkit/arobjectscanningconfiguration)
  - 후면 카메라를 활용해 고성능 공간 데이터를 수집하고 다른 AR 경험에서의 감지를 위한 참조 객체를 생성



`ARSession`의 `run` 메소드에 `ARConfiguration` 서브클래스 오브젝트를 넣어 실행시키면 위에서 언급한 것 처럼 `ARSession`은 내부적으로 `AVCaptureSession`과 `CMMotionManager`를 통해 필요한 데이터를 받아 처리하고 이의 결과물을 초당 60프레임으로  `ARFrame` 객체를 반환한다. 이를 도식화하면 다음과 같다.



<img src="./images/2.png">

다음은 각 요소들의 기능과 대표적인 속성들이다.

- **`ARConfiguration`**

  - 기능을 활성화거나 비활성화할 수 있다.
  - 현재 디바이스가 해당 `ARConfiguration`을 지원하는지를 알 수 있다. (`isSupported`)

- **`ARSession`**

  - AR 프로세싱을 관리한다. 
    - `run`
    - `pause`
  - 트래킹 초기화
    - 카메라 포지션을 초기화 (0, 0, 0)
  - 세션 갱신
    - [`ARSessionDelegate`](https://developer.apple.com/documentation/arkit/arsessiondelegate)
      - `session(_,didAdd:)`
      - `session(_,didUpdate:)`
      - `session(_,didRemove:)`
  - 현재 프레임
    - [`currentFrame`](https://developer.apple.com/documentation/arkit/arsession/2865621-currentframe)

- **`ARFrame`**

  - 캡쳐된 이미지 - 카메라 뷰로부터 캡쳐된 이미지로 배경에 사용된다.
  - 트래킹 데이터 - Orientation, Tracking State
  - 장면 이해 - Feature points, Light Estimation

  > 아래의 그림에서 노란색 십자가들이 Feature point들로 ARKit가 현재 프레임 내에서 특징적인 부분이라고 생각한 지점이다.

  <img src="./images/3.png" width=400>

- **`ARAnchor`**
  - 카메라의 움직임에 따른 오브젝트의 위치와 방향을 트래킹하는데 사용할 수 있으며 구성하는 `ARConfiguration`의 종류에 따라 세션은 자동으로 `ARAnchor`를 추가하기도 한다. 현재 장면에서 오브젝트를 추가하여 해당 위치에 고정시키고 싶다면 `ARAnchor`를 추가하면 된다. 
    - World-Tracking Session - [`ARPlaneAnchor`](https://developer.apple.com/documentation/arkit/arplaneanchor), [`ARObjectAnchor`](https://developer.apple.com/documentation/arkit/arobjectanchor), [`ARImageAnchor`](https://developer.apple.com/documentation/arkit/arimageanchor)
    - Face-Tracking Session - [`ARFaceAnchor`](https://developer.apple.com/documentation/arkit/arfaceanchor)
  - 모든 3D 오브젝트는 기준점을 갖고 있는데 이 기준점과 `ARAnchor`가 만나야 오브젝트는 띄울 수 있다.

> 사실 아직 `ARAnchor`에 대한 명확한 개념이 잡히지 않았다. 내가 궁금한 것은 다음과 같다.
>
> 1. Feature point들과의 차이점. `ARAnchor`도 Feature point들 중 하나인가?
> 2. ARKit이 `ARAnchor`를 정하는 방식
>
> 이에 대한 의문점이 해결되면 추후에 작성해봐야겠다.

----

### Tracking

#### World Tracking

World-Tracking은 다음의 목록에 해당하는 것들을 트래킹한다. 

- 위치와 방향
- 물리적 거리 ( 미터 단위)
- 시작 지점으로부터의 
- 3D-feature points

> 3D-feature point 트래킹은 [WWDC 영상](https://developer.apple.com/videos/play/wwdc2017/602)의 14:50을 확인.

이러한 기능들로 World-Tracking은 다음과 같이 물체는 항상 그 위치에 존재하며 크기 역시 디바이스와의 거리에 따라 달라지며 어느 위치에서 보아도 해당 시점에 해당하는 모습을 보여준다.

<img src="https://docs-assets.developer.apple.com/published/b99f86dcfb/f76d63a3-7620-40d1-9e52-0d9ad6329678.png">

다음과 같이 간단한 코드를 `ARWorldTrackingConfiguration`의 세션을 실행시킬 수 있다.

```swift
let session = ARSession()
session.delegate = self
let configuration = ARWorldTrackingConfiguration()
session.run(configuration)
```

위에서 언급한 것처럼 `ARSession`은 내부적으로 `AVCaptureSession`과 `CMMotionManager`의 도움을 받는다. 이 둘이 제공하는 데이터를 사용하여 하나의 프레임을 생성하는 것이다. 

<img src="./images/4.png">

`AVCaptureSession`의 빈도가 더 적은 것을 볼 수 있다. `AVCaptureSession`을 통한 카메라 뷰의 데이터를 처리하는데는 비교적 많은 계산 시간과 CPU 자원을 필요로 한다. 그리고 `CMMotionManager`의 모션 데이터는 너무 긴 시간동안의 데이터 수집은 오히려 잠재적인 오류들을 포함할 수 있다. 그렇기 때문에 이 둘을 모두 사용하여 하나의 프레임을 적절히 만드는 것이다. 

#### ARCamera

`ARSession`에서 캡쳐된 비디오 프레임에서의 카메라 위치 및 이미지 특성에 대한 정보를 담고 있다. 또한 트래킹 상태([`ARCamera.TrackingState`](https://developer.apple.com/documentation/arkit/arcamera/trackingstate))에 대한 정보 역시 담고 있고 트래킹 상태에 대해서는 밑에서 더 자세히 알아보도록 하자. 

> 카메라 뷰가 활성화되었을 때 후면 카메라가 향하고 있는 방향이 `-z` 방향이다. 카메라의 시작점이 `(0,0,0)`이 된다.

<img src="./images/5.png" width=400>



#### Tracking Quality

트래킹 퀄리티는 다음의 세 가지 요소에 의해 결정된다. 

- 센서 데이터의 흐름성
  - 카메라 뷰가 비활성화되어 시각 데이터를 제공받지 못하는 등의 상황이 된다면 트래킹 퀄리티는 저하된다.
- 질감이 존재하는 환경
  - Feature point, 즉 특징적인 점을 찾을 수 있는 환경이 되어야 한다. 어두운 환경에 있거나 흰 벽을 바라보고 있는 환경에선 트래킹 퀄리티는 저하된다.
- 정적인(*Static*) 장면
  - 너무 빠른 움직임이나 모션 데이터와 이미지 데이터가 불일치하는 경우 트래킹 퀄리티는 저하된다
    - 오르내리는 엘리베이터나 달리는 버스 안 

트래킹 퀄리티는 열거형인 [`ARCamera.TrackingState`](https://developer.apple.com/documentation/arkit/arcamera/trackingstate) 열거형으로 표현되고 세 가지의 케이스가 존재한다.

- `notAvailable` - 트래킹이 시작되지 않은 상태
- `limited(ARCamera.TrackingState.Reason)` - 트래킹 퀄리티가 낮은 상황으로 제공하고자하는 서비스를 제대로 제공할 수 없는 상황으로 이는 그 이유([`ARCamera.TrackingState.Reason`](https://developer.apple.com/documentation/arkit/arcamera/trackingstate/reason))와 함께 제공된다. 
  - 이를 활용해 원할한 트래킹이 가능하도록 사용자의 행동을 유도할 수 있다. (기본 앱인 Measure에서도 면에 대한 충분한 인식이 이루어지지 않으면 측정이 불가능하기 때문에 사용자가 디바이스를 움직이도록 유도한다.)
- `normal` - 트래킹을 하고 있는 보통 상태 

<img src="./images/6.png">



#### Session Interruptions

세션의 흐름은 몇 가지 이유로 끊길 수 있다.

- Camera input unavailable
  - 앱의 백그라운드 진입
  - 아이패드의 멀티태스킹 - 두 앱을 동시에 띄우는 상황
- Trakcing is Stopped

우리는 이러한 세션의 흐름이 끊겼다는 사실을 [`ARSessionObserver`](https://developer.apple.com/documentation/arkit/arsessionobserver) 프로토콜의 메소드를 통해 처리해줄 수 있다.

```swift
func sessionWasInterrupted(_ session: ARSession) {
    showOverlay()
}

func sessionInterruptionEnded(_ session: ARSession) {
    hideOverlay()
}
```

> Interruption은 세션을 수동으로 정지시키는 것과 동일하다. 이 콜백에 대한 응답으로 `pause ()`를 호출하면 인터럽트가 끝날 때 앱에 알림이 전송되지 않습니다

---

### Scene Understanding 

직역하자면 "장면 이해" 정도로 할 수 있다. 즉 현재 실제 세상의 환경을 이해한다는 것인데 어떤 것들을 "이해"하는지 알아보도록 하자.

첫 번째로 만일 하나의 테이블이 존재하고 그 위에 오브젝트를 하나 올린다고 하자. 우리는 이 테이블을 인식할 필요가 있고 이 테이블을 하나의 면(Plane)이라고 인식해야 오브젝트를 단순히 띄우는 것이 아닌 테이블 위에 올려놓을 수 있다. 이를 위해 필요한 것이 **면 감지(Plane Detection)**이다. 

두 번째는 이렇게 면이 감지 되면 오브젝트를 위치시키는데 필요한 3D 좌표점을 찾아야 하는데 이를 위해 사용되는 것이 바로 **Hit-testing**이다. 이러한 좌표점은 디바이스에서 ray를 쏘아 실제 세상과의 교차점이 된다. 

> iOS를 공부해본 사람이라면 Hit-testing이라는 용어가 낯설지 않을 것이다. 바로 디바이스에 터치 이벤트가 발생하였을 때 이 터치가 일어난 View를 찾는 행위를 Hit-testing이라고 한다. 
>
> 본인도 이것에 대해 정리해본 적이 있다. [Hit-testing in iOS](http://baked-corn.tistory.com/128)

세 번째는 오브젝트를 보다 현실적으로 보이기 위해선 주변 환경의 조명에 맞게 반응하도록 하는 것이 중요하다. 이를 위해 사용되는 것이 바로 **빛 판단(Light Estimation)**이다.

이들 각각을 좀 더 자세히 살펴보도록 하자

#### Plane Detection

- **Horizontal with respect to gravity** - 면 감지를 통해 우리는 중력과 관련된 평면을 만들어 제공한다. 위에서와 같이 테이블 면이 될 수도 있고 지면이 될 수도 있다.

- **Runs over multiple frames** -  ARKit는 이를 다수의 프레임으로부터 넘어온 데이터를 바탕으로 감지해내는데 그렇기 때문에 이 행위는 백그라운드에서 돌아간다. 다수의 프레임을 사용하기 때문에 사용자가 디바이스를 움직여 면을 포함하는 프레임이 많아지만다면 면에 대한 인식도가 높아지게 된다. 

- **Aligned extent for surface** 

  > - [This also allows us to retrieve ](https://developer.apple.com/videos/play/wwdc2017-602/?time=1718)[an aligned extent of this plane, ](https://developer.apple.com/videos/play/wwdc2017-602/?time=1722)[which means that we're fitting a ](https://developer.apple.com/videos/play/wwdc2017-602/?time=1724)[rectangle around all detected ](https://developer.apple.com/videos/play/wwdc2017-602/?time=1725)[parts of this plane and align it ](https://developer.apple.com/videos/play/wwdc2017-602/?time=1727)[with the major extent.](https://developer.apple.com/videos/play/wwdc2017-602/?time=1730)
  >   - 영상과 스크립트에는 다음과 같이 설명하고 있다. 하지만 extent라는 것이 정확히 어떤 것을 의미하는지에 대한 이해가 부족하다. 정렬되었다는 것이 무엇을 어떠한 기준으로 정렬하였고 major extent 역시 그 의미가 모호하여 좀 더 공부하 필요하다.
  > - `ARPlaneAnchor`의 `extent` 프로퍼티의 대한 공식 문서의 설명을 살펴보면 감지된 면의 너비와 길이의 추정치라고 설명이 되어있다. 공식 문서의 설명을 덧붙이자면 장면 분석(scene analysis)과 지면 감지가 계속해서 진행될 수록 ARKit는 이전에 감지된 면의 앵커는 실제 세상의 면의 일부라 판단을 하고 `extent`의 너비와 길이 값을 증가시켜간다고 설명되어 있다.

- **Plane merging** - 만일 같은 물리적 면에 여러 가상의 면이 감지된다면 ARKit는 이들을 하나의 면으로 합칠 수 있다. 이렇게 합쳐진 면은 두 면의 크기보다 커질 것이고 그렇게 되면 가장 최근에 인식된 면은 세션으로부터 제거될 것이다. 



#### ARPlaneAnchor

그리고 이렇게 하나의 면이 감지되면 우리는 감지된 면 위에 오브젝트를 위치시킬 수 있는 `ARPlaneAnchor`를 얻을 수 있다. 이는 ARKit에 의해 자동으로 인식된다. 이런식으로 `ARPlaneAnchor`가 감지되면 델리게이트 메소드가 호출된다. 그리고 이렇게 추가된 `ARPlaneAnchor`로 감지된 면을 시각화할 수 있다. 

```swift
func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
    addPlaneGeometry(forAnchors: anchors)
}
```

그리고 위에서 언급한 것 처럼 디바이스를 움직일 수록 면에 대한 인식이 높아지고 이는 기존 면의 확장으로 이어질 수 있다. 그리고 이는 `ARPlaneAnchor`의 갱신으로 이어지는데 이를 통해 `session(_:,didUpdate:)` 메소드가 호출된다.

```swift
func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
    updatePlaneGeometry(forAnchors: anchors)
}
```

이렇게 면이 확장된다면 기존의 중심점은 확장된 면의 중심점으로 옮겨가게 된다. 그리고 앵커가 제거될 때 호출되는 `didRemove(_:,didRemove:)` 메소드 역시 존재한다. 

```swift
func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
    removePlaneGeometry(forAnchors: anchors)
}
```



#### Hit-testing

이제 주변에 면(Plane)이 어디있는지 알고 있다. 그럼 이제 어떻게 이 면에 물체를 위치시키는지에 대해 알아보자. Hit-testing은 이를 위해 사용된다. 

Hit-testing은 디바이스에서 광선을 쏘아서 광선과 실제 세상의 교차점을 찾는 과정이다. 이 과정에는 `ARWorldTrackingConfiguration`과정을 통해 얻은 면이나 3D Feature point 등의 정보들을 활용한다. 그리고 이렇게 찾아낸 교차점들을 거리 순으로 정렬된 결과로 반환한다. 그렇기 때문에 가장 첫 번째 요소는 카메라에서 가장 가까운 교차점이라고 볼 수 있다. 

그리고 이를 수행하는 방법에는 여러 가지 방법이 존재한다. 이는 [`ARHitTestResult.ResultType`](https://developer.apple.com/documentation/arkit/arhittestresult/resulttype)을 통해 지정할 수 있다. 그럼 이 타입들을 하나씩 살펴보도록 하자.

- [`featurePoint`](https://developer.apple.com/documentation/arkit/arhittestresult/resulttype/2875708-featurepoint) - ARKit에 의해 감지된 특징 점들로 감지된 면에 속하지는 않는다. 면 감지를 하기엔 정보가 부족한 상황에서 광선의 교차점 주변의 특징 점들을 반환해준다. 반드시 알고 있어야할 것은 이 점들은 평평한 면에 반드시 속하진 않는다는 것이다. 
  - [`rawFeaturePoints`](https://developer.apple.com/documentation/arkit/arframe/2887449-rawfeaturepoints)
- [`estimatedHorizontalPlane`](https://developer.apple.com/documentation/arkit/arhittestresult/resulttype/2887460-estimatedhorizontalplane) - 면 감지를 통해 우리는 오브젝트를 위치시킬 수 있는 면을 찾는다. 하지만 이러한 과정은 시간이 소요되고 그 대신 우리는 이 옵션을 사용할 수 있다. 하지만 그에 반해 이 옵션의 정확도는 떨어지기 때문에 이미 면이 감지되어 있고 `estimatedHorizontalPlane`과 `existingPlane`을 모두 포함하고 있다면 Hit-testing 결과는 `existingPlane`에 대한 결과만 반환할 것이다. 
- [`estimatedVerticalPlane`](https://developer.apple.com/documentation/arkit/arhittestresult/resulttype/2887455-estimatedverticalplane) - Horizontal과 동일
- [`existingPlane`](https://developer.apple.com/documentation/arkit/arhittestresult/resulttype/2875738-existingplane) - 면 감지에 의해 이미 감지된 면 위의 점들을 결과로 반환하며 면의 너비는 고려하지 않는다. 그렇기 때문에 그 너비는 무한하다고 판단한다.
- [`existingPlaneUsingExtent`](https://developer.apple.com/documentation/arkit/arhittestresult/resulttype/2887459-existingplaneusingextent) - 면 감지에 의해 이미 감지된 면 위의 점들을 결과로 반환하는데 면의 중심과 크기에 의해 정해진 영역안의 속하는 점들만을 결과로 반환한다. 하지만 이 영역은 실제 세상 표면의 일부가 아닌 면이 포함될수도 있고 같은 면에 속하지만 아직 ARKit가 같은 영역이라 판단하지 못한 면도 있을 수 있다. 그렇기 때문에 [`existingPlaneUsingGeometry`](https://developer.apple.com/documentation/arkit/arhittestresult/resulttype/2942264-existingplaneusinggeometry)를 이용해 보다 정확한 판단을 하거나 [`existingPlane`](https://developer.apple.com/documentation/arkit/arhittestresult/resulttype/2875738-existingplane)을 통해 확장된 면의 결과를 사용할 수 있다. 
- [`existingPlaneUsingGeometry`](https://developer.apple.com/documentation/arkit/arhittestresult/resulttype/2942264-existingplaneusinggeometry) - 면 감지에 의해 이미 감지된 면 위의 점들로 면의 예상 크기와 모양 영역 내의 결과로 이는 면의 [`geometry`](https://developer.apple.com/documentation/arkit/arplaneanchor/2941025-geometry)에 의해 정해진 영역 안의 결과들만을 반환한다. 



#### Light Estimation

캡쳐된 이미지의 주변 채도를 기반으로 한다. 1000 루멘을 기본으로 하며 이 기능은 기본적으로 활성화되어 있다. 이 기능을 이용하여 오브젝트에 실제 세상의 채도에 따른 쉐이딩을 적용할 수 있다.

```swift
configuration.isLightEstimatedEnabled = true
let intensity = frame.lightEstimate?.ambientIntensity
let temperature = frame.lightEstimate?.ambientColorTemperature
```





