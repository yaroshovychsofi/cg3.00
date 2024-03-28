
import SwiftUI

struct BezierCurveView: View {
    @State var scale: CGFloat = 50
    @State var ArrayUserVectorT = [Double]()
    @State var UserInputVectorT = String()
    
    @State var updatePointValues = false
    
    @State private var xInput: String = ""
    @State private var yInput: String = ""
    @State var ArrayOfControlPoints = [CGPoint]()
    
    @State var functionPointer: ([CGPoint]) -> [CGPoint] = CalculatePointsForCurve

    

    @State private var alertType: AlertType = .error
    enum AlertType {
        case error, success
    }
    
    
    @State private var methodType: MethodType = .matrix
    enum MethodType: Int, Identifiable, CaseIterable {
        var id: Int { self.rawValue }
        
        case matrix
        case parameter
        
        var description: String {
            switch self {
            case .matrix: return "Матричний"
            case .parameter: return "Параметричний"
            }
        }
    }


    @State private var ShowAlert = false
    @State private var ShowSuccessAlert = false
    @State private var AlertMessage: String = ""
    @State private var foundPointMessage = ""
    @State private var showMatrixInformation = false
    @State private var MatrixMessage = ""
    
    @State var ArrayOfBezierCurvePoints  = [CGPoint]()
    

    var body: some View {
        ScrollView{
            VStack{
                VStack {
                    Text("Масштаб: \(scale, specifier: "%.0f")")
                    Slider(value: $scale, in: 10...100)
                        .foregroundColor(.purple.opacity(0.7))
                        .accentColor(.purple.opacity(0.7))
                    Picker(selection: $methodType, label: Text("Виберіть метод")) {
                        ForEach(MethodType.allCases) { method in
                            Text(method.description).tag(method)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.purple.opacity(0.3))
                    .cornerRadius(5)
                    .accentColor(Color.purple.opacity(0.8))
                    ZStack {
                        
                        GeometryReader { geometry in
                            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                            
                            ZStack {
                                // Решітка координат
                                Path { path in
                                    for i in stride(from: 0, to: geometry.size.width / 2, by: scale) {
                                        path.move(to: CGPoint(x: center.x + i, y: 0))
                                        path.addLine(to: CGPoint(x: center.x + i, y: geometry.size.height))
                                        path.move(to: CGPoint(x: center.x - i, y: 0))
                                        path.addLine(to: CGPoint(x: center.x - i, y: geometry.size.height))
                                    }
                                    
                                    for i in stride(from: 0, to: geometry.size.height / 2, by: scale) {
                                        path.move(to: CGPoint(x: 0, y: center.y + i))
                                        path.addLine(to: CGPoint(x: geometry.size.width, y: center.y + i))
                                        path.move(to: CGPoint(x: 0, y: center.y - i))
                                        path.addLine(to: CGPoint(x: geometry.size.width, y: center.y - i))
                                    }
                                }
                                .stroke(Color.white.opacity(0.7), lineWidth: 1)
                                Path { path in
                                    path.move(to: CGPoint(x: center.x, y: 0))
                                    path.addLine(to: CGPoint(x: center.x, y: geometry.size.height))
                                    path.move(to: CGPoint(x: 0, y: center.y))
                                    path.addLine(to: CGPoint(x: geometry.size.width, y: center.y))
                                }
                                .stroke(Color.white, lineWidth: 2)
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 8, height: 8)
                                    .position(center)
                                
                                Path { path in
                                    path.move(to: CGPoint(x: center.x + scale, y: center.y - 5))
                                    path.addLine(to: CGPoint(x: center.x + scale, y: center.y + 5))
                                    path.move(to: CGPoint(x: center.x - 5, y: center.y - scale))
                                    path.addLine(to: CGPoint(x: center.x + 5, y: center.y - scale))
                                }
                                .stroke(Color.white, lineWidth:3)
                                
                                ForEach(-4...4, id: \.self) { i in
                                    if i != 0 {
                                        Text("\(i)")
                                            .foregroundColor(.white)
                                            .position(x: center.x + CGFloat(i) * scale, y: center.y + 15)
                                            .font(.system(size: 16, design: .default).weight(.bold))
                                        Text("\(i)")
                                            .foregroundColor(.white)
                                            .position(x: center.x - 15, y: center.y - CGFloat(i) * scale)
                                            .font(.system(size: 16, design: .default).weight(.bold))
                                        
                                    }
                                }
                                drawBezierCurve(in: geometry.size)
                                if(ArrayOfControlPoints.count != 0)
                                {
                                    ForEach(ArrayOfControlPoints.indices, id: \.self) { index in
                                        Circle()
                                            .fill(Color.red)
                                            .frame(width: 7, height: 7)
                                            .position(x:center.x + ArrayOfControlPoints[index].x * scale,
                                                      y:center.y - ArrayOfControlPoints[index].y * scale)
                                    }
                                }
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .aspectRatio(contentMode: .fit)
                        .background(Color.purple.opacity(0.6))
                        .cornerRadius(10)
                        
                        
                        
                        //отут
                        
                    }
                    
                    VStack(alignment: .center) {
                        if showMatrixInformation{
                            
                            Text(MatrixMessage)
                                .multilineTextAlignment(.center)
                                .padding(10)
                                .frame(width: 350)
                                .background(Color.purple.opacity(0.5))
                                .cornerRadius(10.0)
                                .frame(maxWidth: 350)
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .bold, design: .serif))
                        }
                        
                        
                        Text("Введіть координати точки, щоб додати:)")
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, maxHeight: 40)
                            .padding()
                            .background(Color.purple.opacity(0.5))
                            .cornerRadius(10.0)
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .regular, design: .serif))
                        HStack{
                            VStack{
                                TextField("Введіть x", text: $xInput)
                                    .padding(15)
                                    .frame(maxWidth: .infinity, maxHeight: 40)
                                    .background(Color.purple.opacity(0.2))
                                    .cornerRadius(5.0)
                                
                                TextField("Введіть y", text: $yInput)
                                    .padding(15)
                                    .frame(maxWidth: .infinity, maxHeight: 40)
                                    .background(Color.purple.opacity(0.2))
                                    .cornerRadius(5.0)
                            }
                            Button("Додати точку"){
                                addPoint()
                                MatrixMessage=""
                                if ArrayOfControlPoints.count > 3
                                {
                                    switch methodType {
                                    case .matrix:
                                        functionPointer = CalculatePointsForCurve(controlPointsInCG:)
                                    case .parameter:
                                        functionPointer = CalculatePointsParamMethod(controlPoints:)
                                        
                                        
                                    }
                                    ArrayOfBezierCurvePoints = functionPointer(ArrayOfControlPoints)
                                    if methodType == .matrix {
                                        MatrixMessage += "Сума кожного рядка матриці Безьє відповідно:\n"
                                        let num = ArrayOfControlPoints.count
                                        let sum = sumOfRows(in: calculateBeizerMatrix(number: num-1))
                                        for index in 0..<sum.count {
                                            MatrixMessage += "\(index + 1)-ий рядок: \(sum[index])\n"
                                            self.showMatrixInformation = true
                                        }
                                    }
                                    
                                }
                            }
                            .padding(15)
                            .frame(maxWidth: 200, maxHeight: 300)
                            .background(Color.purple.opacity(0.2))
                            .cornerRadius(5.0)
                            .foregroundColor(Color.purple.opacity(0.7))
                            .font(.system(.body, design: .default).weight(.bold))
                            
                        }
                        .frame(maxWidth: .infinity)
                        Text("Введіть список параметрів  \n0 < t < 1\n    через кому, для яких обчислити точки ")
                            .multilineTextAlignment(.center)
                            .padding(10)
                            .frame(maxWidth: .infinity)
                            .background(Color.purple.opacity(0.5))
                            .cornerRadius(10.0)
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .bold, design: .serif))
                        
                        
                        HStack{
                            TextField("Cписок параметрів t", text: $UserInputVectorT)
                                .padding(15)
                                .frame(maxWidth: .infinity, maxHeight: 40)
                                .background(Color.purple.opacity(0.2))
                                .cornerRadius(5.0)
                            
                            Button("Знайти точки") {
                                self.ShowAlert = false
                                self.ShowSuccessAlert = false
                                foundPointMessage = ""
                                UserInputVectorT = ""
                                let stringArray = UserInputVectorT.components(separatedBy: ",")
                                let doubleArray = stringArray.compactMap { Double($0) }
                                ArrayUserVectorT.append(contentsOf: doubleArray)
                                if (ArrayUserVectorT.count == 0) && (ArrayOfControlPoints.count < 4) {
                                    self.ShowAlert = true
                                    self.alertType = .error
                                    AlertMessage = "Переконайтесь, що у вас достатньо точок для побудови кривої і ви ввели параметр t для пошуку точок"
                                } else if ArrayOfControlPoints.count < 4 {
                                    self.ShowAlert = true
                                    self.alertType = .error
                                    AlertMessage = "У вас недостатньо контрольних точок для кривої"
                                } else if ArrayUserVectorT.count == 0 {
                                    self.ShowAlert = true
                                    self.alertType = .error
                                    AlertMessage = "Ви не ввели список параметрів t"
                                } else {
                                    self.ShowAlert = true
                                    self.ShowSuccessAlert = true
                                    self.alertType = .success
                                    let resultForUser = findPointsByUserVectorT(vectorT: ArrayUserVectorT, controlPointsInCG: ArrayOfControlPoints)
                                    for index in 0..<resultForUser.count {
                                        foundPointMessage += ("Координати точки за параметром \nt = \(String(format: "%.2f", ArrayUserVectorT[index])): x = \(String(format: "%.3f", resultForUser[index].x)), y = \(String(format: "%.3f", resultForUser[index].y))\n")
                                    }
                                    
                                }
                                
                            }
                            .frame(maxWidth: 200, maxHeight: 40)
                            .background(Color.purple.opacity(0.2))
                            .cornerRadius(5.0)
                            .foregroundColor(Color.purple.opacity(0.7))
                            .font(.system(.body, design: .default).weight(.bold))
                            .alert(isPresented: $ShowAlert) {
                                switch alertType {
                                case .error:
                                    return Alert(title: Text("Отакої, помилка🤯"), message: Text(AlertMessage), dismissButton: .default(Text("OK")))
                                case .success:
                                    return Alert(title: Text("Координати точок за параметрами t"), message: Text("\(foundPointMessage)"), dismissButton: .default(Text("OK")))
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        if(ArrayOfControlPoints.count>0){
                            VStack{
                                ForEach(ArrayOfControlPoints.indices, id: \.self) { index in
                                    HStack {
                                        TextField(
                                            "",
                                            text: Binding<String>(
                                                get: {
                                                    String(format: "%.1f", self.ArrayOfControlPoints[index].x)
                                                },
                                                set: { newValue in
                                                    if let value = NumberFormatter().number(from: newValue) {
                                                        self.ArrayOfControlPoints[index].x = CGFloat(value.doubleValue)
                                                    }
                                                }
                                            )
                                        ).textFieldStyle(RoundedBorderTextFieldStyle())
                                        
                                        TextField(
                                            "",
                                            text: Binding<String>(
                                                get: {
                                                    String(format: "%.1f", self.ArrayOfControlPoints[index].y)
                                                },
                                                set: { newValue in
                                                    if let value = NumberFormatter().number(from: newValue) {
                                                        self.ArrayOfControlPoints[index].y = CGFloat(value.doubleValue)
                                                    }
                                                }
                                            )
                                        ).textFieldStyle(RoundedBorderTextFieldStyle())
                                        Button("☑️") {
                                            if let xValue = NumberFormatter().number(from: xInput)?.doubleValue,
                                               let yValue = NumberFormatter().number(from: yInput)?.doubleValue {
                                                ArrayOfControlPoints[index] = CGPoint(x: xValue, y: yValue)
                                            }
                                            if ArrayOfControlPoints.count > 3
                                            {
                                                ArrayOfBezierCurvePoints = functionPointer(ArrayOfControlPoints)
                                                
                                            }
                                        }
                                    }
                                }
                            }
                            .padding()
                            .frame(width: 350)
                            .background(Color.purple.opacity(0.2))
                            .cornerRadius(5)
                            
                            
                        }
                        
                    }
                    
                }
            }
        }
        .padding()
    }

    private func drawBezierCurve(in size: CGSize) -> some View {
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        
        return ZStack {
            Path { path in

                if ArrayOfBezierCurvePoints.count > 1 {
                    let scaledPoints = ArrayOfBezierCurvePoints.map { point -> CGPoint in
                        let scaledX = center.x + point.x * scale
                        let scaledY = center.y - point.y * scale
                        return CGPoint(x: scaledX, y: scaledY)
                    }
                    path.move(to: scaledPoints.first!)
                    for point in scaledPoints.dropFirst() {
                        path.addLine(to: point)
                    }
                }
            }
            .stroke(Color.blue.opacity(0.8), lineWidth: 5)
            .cornerRadius(2.0)
            
        }
        .onAppear {
            addPoint()
            if ArrayOfControlPoints.count > 3 {
                            ArrayOfBezierCurvePoints = functionPointer(ArrayOfControlPoints)
                        }
            
        }
        .onChange(of: ArrayOfControlPoints) { oldState, newState in
           
        }
        .onChange(of: scale) { oldState, newState in}
    }
    
    
    private func addPoint() {
        if let x = Double(xInput), let y = Double(yInput) {
            let newPoint = CGPoint(x: x, y: y)
            ArrayOfControlPoints.append(newPoint)
            xInput = ""
            yInput = ""
        }
    }
    
}


#Preview {
    BezierCurveView()
}
