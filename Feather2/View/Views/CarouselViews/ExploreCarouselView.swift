//
//  ExploreCarouselView.swift
//  PersistenceTest
//
//  Created by Charles Diggins on 1/30/23.
//


import SwiftUI

struct ExploreCarouselView : View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var languageViewModel: LanguageViewModel
    @EnvironmentObject var router: Router
    @State var exerciseManager : ExerciseDataManager
    @State var index = 0
    @Binding var selected : Bool
    @State var show = false
    @State var currentIndex = 0
    @State var data = [ExerciseData]()

    var body: some View{
        
        ZStack{
            if data.count > 0 {
                
                VStack{
                    
                    HStack{
                        Text("\(exerciseManager.getExerciseMode().rawValue) Mode")
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                        
                        Text("\(self.index + 1)/\(self.data.count)")
                            .foregroundColor(.red)
                            .font(.title2)
                            .onChange(of: index){_ in
                                languageViewModel.setCurrentExercise(exercise: exerciseManager.get(index))
                            }
                    }
//                    .padding(.top)
//                    .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
//                    .padding()
                    
                    GeometryReader{g in
                        Carousel(data: self.$data, index: self.$index, show: self.$show, size: g.frame(in: .global))
                    }
                    .padding(.bottom, (UIApplication.shared.windows.first?.safeAreaInsets.bottom)! + 10)
                }
                // hiding the view when expand view appears..
                .opacity(self.show ? 0 : 1)
                
                // Current index will give current card...
//                ExpandView(data: self.$data[self.index], show: self.$show, selected: self.$selected)
//                //shrinking the view in background...
//                    .scaleEffect(self.show ? 1 : 0)
//                    .frame(width: self.show ? nil : 0, height: self.show ? nil : 0)
            }
        }
        .background(Color.black.opacity(0.07).edgesIgnoringSafeArea(.all))
//        .edgesIgnoringSafeArea(.all)
//        .onChange(of: selected){_ in
//            print("The exercise index \(self.index) was selected")
//            dismiss()
//        }
        .onChange(of: show){_ in
            languageViewModel.setCurrentExerciseMode(mode: exerciseManager.getExerciseMode())
//            print("ExploreCarouselView: onChange: currentExercise: \(exerciseManager.get(index)) at index \(index)")
            languageViewModel.setCurrentExercise(exercise: exerciseManager.get(index))
            selected.toggle()
        }
        .onDisappear{
        }
        .onAppear{
            languageViewModel.setCurrentExerciseMode(mode: exerciseManager.getExerciseMode())
            languageViewModel.setCurrentExercise(exercise: exerciseManager.get(index))
            data = exerciseManager.getActiveArray()
//            print("onAppear: index = \(self.index)")
//            for d in data{
//                print("Current exercise \(d.id). \(d.title)")
//            }
        }
    }
    
}

// Carousel List...

struct HScrollView : View {
    
    @Binding var data : [ExerciseData]
    // for expanding view...
    @Binding var show : Bool
    var size : CGRect
    
    var body: some View{
        
        HStack(spacing: 0){
            
            ForEach(self.data){i in
                
//                ZStack(alignment: .bottom){
                ScrollView{
                    Text(i.title)
                        .font(.title)
                        .fontWeight(.bold)
                    Image(i.image)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
//                    .frame(width: self.size.width - 30, height: self.size.height)
                    .cornerRadius(25)
                    // because fill will take extra space we avoid this by contentshape....
//                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation{
                            
                            // open the expand view when image is tapped...
                            
                            self.show.toggle()
                        }
                    }
                    Text(i.details)
                    Spacer()
                }
                // fixed frame for carousel list...
                .frame(width: self.size.width, height: self.size.height)
            }
        }
        .foregroundColor(Color("BethanyGreenText"))
        .background(Color("BethanyNavalBackground"))
    }
}

// ExpandView...

//struct ExpandView : View {
//    @Environment(\.dismiss) private var dismiss
//    @Binding var data : ExerciseData
//    @Binding var show : Bool
//    @Binding var selected : Bool
//    
//    var body: some View{
//        
//        VStack{
//            
//            // dismiss Button...
//            
//            ZStack(alignment: .topTrailing) {
//                
//                Image(self.data.image)
//                .resizable()
//                .cornerRadius(25)
//                
//                Button(action: {
//                    
//                    // dismissing the expand view...
//                    
//                    withAnimation{
//                        
//                        self.show.toggle()
//                    }
//                    
//                }) {
//                    
//                    Image(systemName: "xmark")
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color.black.opacity(0.7))
//                        .clipShape(Circle())
//                }
//                .padding(.trailing)
//                .padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top)! + 10)
//            }
//            
//            VStack(alignment: .leading, spacing: 12){
//                
//                Text(self.data.title)
//                    .font(.title)
//                    .fontWeight(.bold)
//                
//                HStack(spacing: 12){
//                    
//                    Image(systemName: "mappin.circle.fill")
//                        .font(.system(size: 25, weight: .bold))
//                    
//                    Text(self.data.studentLevel)
//                        .foregroundColor(.gray)
//                    
//                    Image(systemName: "star.fill")
//                        .foregroundColor(.yellow)
//                        .padding(.leading,5)
//                    
////                    Text("5")
////                        .foregroundColor(.gray)
//                }
//                
//                Text(self.data.details)
//            }
//            .padding(.horizontal,25)
//            .padding(.bottom,20)
//            .foregroundColor(.black)
//            .padding(.top)
//            
//            HStack{
//                
////                HStack(spacing: 15){
////
////                    Text("$ 450")
////                        .font(.title)
////                        .fontWeight(.bold)
////
////                    Text("( 3 Days )")
////                        .font(.title)
////                }
////                .padding(.leading, 20)
//                
//                Spacer()
//                
//                Button(action: {
//                    self.selected = true
//                    self.show.toggle()
//                }) {
//                    
//                    Text("Select this")
////                        .foregroundColor(.white)
//                        .font(.system(size: 22))
//                        .padding(.vertical, 25)
//                        .frame(width: UIScreen.main.bounds.width / 2.5)
////                        .background(Color("Color"))
//                        .clipShape(CShape())
//                        .foregroundColor(Color("BethanyGreenText"))
//                        .background(Color("BethanyNavalBackground"))
//                }
//            }
//        }
//    }
//}

struct Carousel : UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        
        return Carousel.Coordinator(parent1: self)
    }
    
    @Binding var data : [ExerciseData]
    @Binding var index : Int
    @Binding var show : Bool
    var size : CGRect
    
    func makeUIView(context: Context) -> UIScrollView {
        
        let view = UIScrollView()
        // because each view takse full width so content size will be * total count...
        view.contentSize = CGSize(width: size.width * CGFloat(data.count), height: size.height)
        
        let child = UIHostingController(rootView: HScrollView(data: self.$data, show: self.$show, size: self.size))
        child.view.backgroundColor = .clear
        // same here....
        child.view.frame = CGRect(x: 0, y: 0, width: size.width * CGFloat(data.count), height: size.height)
        
        view.addSubview(child.view)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        view.delegate = context.coordinator
        
        return view
        
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        
        // dynamically update size when new data added...
        
        for i in 0..<uiView.subviews.count{
            
            uiView.subviews[i].frame = CGRect(x: 0, y: 0, width: size.width * CGFloat(data.count), height: size.height)
        }
        
        uiView.contentSize = CGSize(width: size.width * CGFloat(data.count), height: size.height)
    }
    
    class Coordinator : NSObject,UIScrollViewDelegate{
        
        var parent : Carousel
        
        init(parent1 : Carousel) {
            
            parent = parent1
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
         
            let offset = scrollView.contentOffset.x * 1.1  //compensates for the card width less than scroll length
            let index = Int( offset / UIScreen.main.bounds.width)
            parent.index = index
        }
    }
}


// Custom Shape

struct CShape : Shape {
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.bottomRight], cornerRadii: CGSize(width: 55, height: 55))
        
        return Path(path.cgPath)
    }
}

// To Hide Home Indicator...

class Host : UIHostingController<ExploreCarouselView>{
    
    override var prefersHomeIndicatorAutoHidden: Bool{
        
        return true
    }
}
