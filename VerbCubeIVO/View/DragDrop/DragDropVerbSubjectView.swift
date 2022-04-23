//
//  DragDropVerbSubjectView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 4/1/22.
//

import SwiftUI
import JumpLinguaHelpers

struct DragDropVerbSubjectView: View {
//    @Environment(\.dismiss) private var dismiss
    // Mark: properties
    @State var progress : CGFloat = 0
    @State var verbWordsFrom: [DragDrop2Word] = wordMatch
    @State var subjectWordsTo: [DragDrop2Word] = wordMatch
    
    // Mark: Custom Grid Arrays
    //for drag part
    @State var shuffledRows: [[DragDrop2Word]] = []
    //for drop part
    @State var rows: [[DragDrop2Word]] = []
    
    @State var animateWrongText : Bool = false
    @State var droppedCount : CGFloat = 0
    @State var droppedCountInt = 0
    
    
    var body: some View {
        VStack{
            Image("JLCropSmall")
                .frame(width:200, height:100)
                .aspectRatio(contentMode: .fit)
                .padding(.trailing, 5)
                .padding(10)
            VStack(spacing: 15){
                //            NavBar()
                HStack{
                    Button{
                        let newChallenge = fillNewDragDropWords()
                        verbWordsFrom = newChallenge
                        subjectWordsTo = newChallenge
                        verbWordsFrom = verbWordsFrom.shuffled()
                        shuffledRows = generateGridFrom()
                        verbWordsFrom = wordMatch
                        rows = generateGridTo()
                        droppedCount = 0
                        droppedCountInt = 0
                        progress = 0
                    } label: {
                        Text("Load new challenge")
                            .bold()
                            .frame(width: 200, height: 30)
                            .foregroundColor(.indigo)
                            .background(.linearGradient(colors: [.mint, .white], startPoint: .bottomLeading, endPoint: .topTrailing))
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .shadow(radius: 3)
                    }
                    
                    Button{
                        //                    dismiss()
                    } label : {
                        Text("Cancel")
                            .bold()
                            .frame(width: 100, height: 30)
                            .foregroundColor(.indigo)
                            .background(.linearGradient(colors: [.white, .mint], startPoint: .bottomLeading, endPoint: .topTrailing))
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .shadow(radius: 3)
                    }
                }.padding(5)
                
                VStack(alignment: .leading, spacing: 30){
                    Text("Drag the verbs to the subjects")
                        .font(.title2.bold())
                    
                    Text("Number completed: \(Int(droppedCount)) out of \(verbWordsFrom.count)")
                        .background(.linearGradient(colors: [.yellow, .orange], startPoint: .bottomLeading, endPoint: .topTrailing))
                }
                .padding(.top, 30)
                
                
                
                
                // Mark: Drag Drop Area
                DropArea()
                    .padding(.vertical, 15)
                    .background(.yellow)
                
                
                
                DragArea()
                    .padding(.vertical, 15)
                    .background(.red)
                
                
            }.padding()
        }
            .onAppear{
                if rows.isEmpty{
                    //first creating shuffled one
                    //then creating normal one
                    verbWordsFrom = verbWordsFrom.shuffled()
                    shuffledRows = generateGridFrom()
                    verbWordsFrom = wordMatch
                    rows = generateGridTo()
                }
            }
            .offset(x: animateWrongText ? -30 : 0)
    }
    
    // Mark: Drop area
    @ViewBuilder
    func DropArea()->some View{
        VStack(spacing: 6){
            ForEach($rows, id: \.self){ $row in
                HStack(spacing: 10){
                    ForEach($row){$item in
                        Text(item.valueFrom)
                            .font(.system(size: item.fontSize))
                            .padding(.vertical, 5)
                            .padding(.horizontal, item.padding)
                            .foregroundColor(.black)
//                            .opacity(item.isShowing ? 1 : 0)
                            .background(){
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(item.isShowing ? .clear : .gray.opacity(0.25))
                            }
                            .background(){
                                //if item is dropped into the correct place
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .stroke(.gray)
                                    .opacity(item.isShowing ? 1 : 0)
                                    .background(item.isShowing ? .green : .clear)
                            }
                        // Mark: adding the drop operation here
                            .onDrop(of: [.url], isTargeted: .constant(false)){
                                providers in
                                if let first = providers.first{
                                    let _ = first.loadObject(ofClass: URL.self){
                                        value, error in
                                        guard let url = value else{return}
                                        if replaceAccentWithDoubleLetter(characterArray: item.valueTo) == "\(url)"{
                                            droppedCount += 1
                                            droppedCountInt = droppedCountInt
//                                            print("onDrop: \(item)")
                                            let progress = (droppedCount / CGFloat(subjectWordsTo.count))
                                            withAnimation{
                                                item.isShowing = true
                                                updateShuffledArray(ddWord: item)
                                                self.progress = progress
                                            }
                                        }
                                        //animating when wrong text is dropped
                                        else {
                                            animateView()
                                        }
                                        
                                    }
                                }
                                
                                return false
                            }
                    }
                }
                if rows.last != row {
                    Divider()
                }
            }
        }
    }
    
    func areEqualStrings(str1: String, str2: String)->Bool{
        if str1 == str2 {return true}
        return false
    }
    
    @ViewBuilder
    func DragArea()->some View{
        VStack(spacing: 6){
            ForEach(shuffledRows, id: \.self){ row in
                HStack(spacing: 10){
                    ForEach(row){item in
                        Text(item.valueTo)
                            .font(.system(size: item.fontSize))
                            .foregroundColor(.black)
                            .padding(.vertical, 5)
                            .padding(.horizontal, item.padding)
                            .background(){
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .stroke(.gray)
                            }
                        // Mark: adding drag here
                            .onDrag{
                                return .init(contentsOf: URL(string: replaceAccentWithDoubleLetter(characterArray: item.valueTo)))!
                            }
                            .opacity(item.isShowing ? 0 : 1)
                            .background(){
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(item.isShowing ? .gray.opacity(0.25) : .clear)
                            }
                        
                    }
                }
                if shuffledRows.last != row {
                    Divider()
                }
            }
        }
    }
    
    // Mark: Custom Nav Bar
    @ViewBuilder
    func NavBar()->some View{
        HStack(spacing: 18){
            Button{
                
            } label: {
                Image(systemName: "xmark")
                    .font(.title)
                    .foregroundColor(.gray)
            }
            
            GeometryReader{proxy in
                ZStack(alignment: .leading){
                    Capsule()
                        .fill(.gray.opacity(0.25))
                    Capsule()
                        .fill(Color("Green"))
                        .frame(width: proxy.size.width * progress)
                }
            }.frame(height: 20)
            
            Button{
                
            } label: {
                Image(systemName: "suit.heart.fill")
                    .font(.title)
                    .foregroundColor(.red)
            }
        }
        
    }
    
    //Mark: Generating custom grid columns
    func generateGridFrom()->[[DragDrop2Word]]{
        //Step 1
        //Identifying each text width and updating it into State Variable
        for item in verbWordsFrom.enumerated(){
            let textSize = textSize(ddWord: item.element)
            verbWordsFrom[item.offset].textSize = textSize
        }
        var gridArray: [[DragDrop2Word]] = []
        var tempArray: [DragDrop2Word] = []
        
        //currentWidth
        var currentWidth: CGFloat = 0
        //-30 -> Horizontal padding
        var totalScreenWidth: CGFloat = UIScreen.main.bounds.width - 30
        
        for character in verbWordsFrom {
            currentWidth += character.textSize
            if currentWidth < totalScreenWidth {
                tempArray.append(character)
            } else {
                gridArray.append(tempArray)
                tempArray = []
                currentWidth = character.textSize
                tempArray.append(character)
            }
        }
        
        // checking exhaust
        if !tempArray.isEmpty{
            gridArray.append(tempArray)
        }
        return gridArray
    }
    
    //Mark: Generating custom grid columns
    func generateGridTo()->[[DragDrop2Word]]{
        //Step 1
        //Identifying each text width and updating it into State Variable
        for item in subjectWordsTo.enumerated(){
            let textSize = textSize(ddWord: item.element)
            subjectWordsTo[item.offset].textSize = textSize
        }
        var gridArray: [[DragDrop2Word]] = []
        var tempArray: [DragDrop2Word] = []
        
        //currentWidth
        var currentWidth: CGFloat = 0
        //-30 -> Horizontal padding
        var totalScreenWidth: CGFloat = UIScreen.main.bounds.width - 30
        
        for character in subjectWordsTo {
            currentWidth += character.textSize
            if currentWidth < totalScreenWidth {
                tempArray.append(character)
            } else {
                gridArray.append(tempArray)
                tempArray = []
                currentWidth = character.textSize
                tempArray.append(character)
            }
        }
        
        // checking exhaust
        if !tempArray.isEmpty{
            gridArray.append(tempArray)
        }
        return gridArray
    }
    
    //identifying the text size
    func textSize(ddWord: DragDrop2Word)->CGFloat{
        let font = UIFont.systemFont(ofSize: ddWord.fontSize)
        let attributes = [NSAttributedString.Key.font : font]
        let size = (ddWord.valueFrom as NSString).size(withAttributes: attributes)
        //horizontal padding
        return size.width + (ddWord.padding * 2) + 15
    }
    
    // Mark: Updating the shuffled array (bottom)
    func updateShuffledArray(ddWord: DragDrop2Word){
        for index in shuffledRows.indices {
            for subIndex in shuffledRows[index].indices{
                if shuffledRows[index][subIndex].id == ddWord.id {
                    shuffledRows[index][subIndex].isShowing = true
                }
            }
        }
    }
    
    // Mark: animating wrong text view
    func animateView(){
        withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.2, blendDuration: 0.2))
        {
            animateWrongText = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 ){
            withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.2, blendDuration: 0.2))
            {
                animateWrongText = false
            }
        }
        
    }
}

struct DragDropVerbSubjectView_Previews: PreviewProvider {
    static var previews: some View {
        DragDropVerbSubjectView()
    }
}
