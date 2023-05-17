//
//  OpenCardView.swift
//  Hyoza
//
//  Created by HAN GIBAEK on 2023/05/12.
//

import SwiftUI

struct OpenCardView: View {
    @Environment(\.displayScale) var displayScale
    
    var imageToShareInQuestionCard: ImageWrapper? = nil
    
    @Binding var degree: Double
    @Binding var selectedQuestion: Question?
    @State var todayAnsweredQuestion: Question? = nil
    
    var body: some View {
        ZStack {
            if todayAnsweredQuestion != nil {
                AnswerView(todayAnsweredQuestion: $todayAnsweredQuestion)
                    .rotation3DEffect(Angle(degrees: degree), axis: (0, 1, 0))
                    .onAppear() {
                        _ = AttendanceManager().updateAttendance()
                        NotificationCenter.default.post(name: AttendanceManager.notificationAttendanceUpdate, object: nil)
                    }
            } else {
                NoAnswerView(selectedQuestion: $selectedQuestion)
                    .rotation3DEffect(Angle(degrees: degree), axis: (0, 1, 0))
            }
        }
        .onAppear {
            todayAnsweredQuestion = PersistenceController.shared.todayAnsweredQuestion
        }
    }
}

struct NoAnswerView: View {
    @Environment(\.displayScale) var displayScale
    @State var imageToShareInQuestionCard: ImageWrapper? = nil
    @Binding var selectedQuestion: Question?
    
    var body: some View {
        if let selectedQuestion = selectedQuestion {
            GeometryReader { geo in
                VStack{
                    OpenCardTitleView(difficulty: selectedQuestion.difficultyString,
                                      targetView: self)
                    Spacer()
                    Text(selectedQuestion.wrappedQuestion)
                        .font(.title)
                        .foregroundColor(.textColor)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 5)
                    Spacer()
                    NavigationLink {
                        QnAView(data: selectedQuestion, isEditing: true)
                    } label: {
                        ButtonView(content: "답변하기")
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                    }
                }
            }
        } else {
            Text("Here idiot")
        }
    }
}

struct OpenCardTitleView: View {
    let difficulty: String
    let horizontalPadding: CGFloat = 10
    let topPadding: CGFloat = 10
    let targetView: any View
    
    var body: some View {
        ZStack {
            HStack {
                DifficultyCapsuleView(difficulty: difficulty)
                    .padding(.leading, horizontalPadding)
                Spacer()
                ShareButtonView(content: AnyView(targetView))
                    .padding(.trailing, horizontalPadding)
            }
            HStack {
                Spacer()
                Text(Date().fullString)
                    .font(.subheadline)
                    .foregroundColor(.textSecondaryColor)
                Spacer()
            }
        }
        .padding(.top, topPadding)
    }
}

struct AnswerView: View {
    @Environment(\.displayScale) var displayScale
    var imageToShareInQuestionCard: ImageWrapper? = nil
    @Binding var todayAnsweredQuestion: Question?
    
    var body: some View {
        if let todayAnsweredQuestion = todayAnsweredQuestion {
//<<<<<<< HEAD
//            VStack{
//                    HStack {
//                        CapsuleView(content: {
//                            Text(todayAnsweredQuestion.difficultyString)
//                                .font(.footnote)
//                                .foregroundColor(.textOrange)
//                                .padding([.leading, .trailing], 12)
//                                .padding([.top, .bottom], 4)
//                        }, capsuleColor: .backGroundLightOrange)
//                        Spacer()
//                        Text(Date().fullString)
//                            .font(.footnote)
//                            .foregroundColor(.tapBarDarkGray)
//                        Spacer()
//                        ShareButtonView(content: AnyView(self))
//                    }
//=======
            NavigationLink {
                QnAView(data: todayAnsweredQuestion, isEditing: false)
            } label: {
                VStack{
//<<<<<<< HEAD
//                    OpenCardTitleView(difficulty: todayAnsweredQuestion.difficultyString)
////>>>>>>> f2fdf9c4124d76bdb836d8271ff8dc57e3aaf789
//=======
                    OpenCardTitleView(difficulty: todayAnsweredQuestion.difficultyString,
                                      targetView: self)
//>>>>>>> 6aecae32a14c99b05163ae2fb2b8c9e2584ed665
                    Spacer()
                    Text(todayAnsweredQuestion.wrappedQuestion)
                        .font(.title)
                        .foregroundColor(.textColor)
                        .bold()
                        .multilineTextAlignment(.center)
//<<<<<<< HEAD
//=======
                        .padding(.horizontal, 5)
//>>>>>>> f2fdf9c4124d76bdb836d8271ff8dc57e3aaf789
                    Spacer()
                    Text(todayAnsweredQuestion.answer?.answerDetail ?? "답변이 없습니다")
                        .font(.title3)
//<<<<<<< HEAD
//                        .foregroundColor(.textBlack)
//                        .multilineTextAlignment(.center)
//=======
                        .foregroundColor(.textColor)
//>>>>>>> 67208d27e3df7887f3c91de5551db02c5c4e391b
                    Spacer()
                }
            }
        }
    }
}

struct ShareButtonView: View {
    @Environment(\.displayScale) var displayScale
    @State var imageToShareInQuestionCard: ImageWrapper? = nil
    
    let content: AnyView
    
    var body: some View {
        Button(action: {
            let viewToRender = content.frame(idealWidth: UIScreen.main.bounds.width, minHeight: 500)
            
            guard let image = viewToRender.render(scale: displayScale) else {
                return
            }
            imageToShareInQuestionCard = ImageWrapper(image: image)
        }) {
            Image(systemName: "square.and.arrow.up")
                .foregroundColor(.textPointColor)
                .font(.title3)
        }
        .sheet(item: $imageToShareInQuestionCard) { imageToShareInQuestionCard in
            ActivityViewControllerWrapper(items: [imageToShareInQuestionCard.image], activities: nil)
        }
    }
}

struct OpenCardView_Previews: PreviewProvider {
    static var previews: some View {
        let pc = PersistenceController.preview
        OpenCardView(degree: .constant(90), selectedQuestion: .constant(pc.easyQuestions[0]))
        OpenCardView(degree: .constant(0), selectedQuestion: .constant(pc.easyQuestions[0]))
    }
}
