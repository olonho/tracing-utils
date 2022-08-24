//@Entry
@Component
@Preview
struct Index {
  @State message: string = 'Hello World'

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}

@Entry
@Preview
@Component
struct App {
  @State widthSize: number = 200
  @State heightSize: number = 100
  private flag: boolean = true
  build() {
    Column() {
      Button('Hello')
        .width(this.widthSize)
        .height(this.heightSize)
        .backgroundColor(0x317aff)
        .onAppear(() => {
          animateTo({
            duration: 8000,
            tempo: 1.0,
            curve: Curve.EaseInOut,
            delay: 0,
            iterations: 1000,
            playMode: PlayMode.AlternateReverse
          }, () => {
            this.widthSize = this.flag ? 100 : 200
            this.heightSize = this.flag ? 50 : 100
            this.flag = !this.flag
          })
        })
    }.width('100%').margin({ top: 5 })
  }
}

