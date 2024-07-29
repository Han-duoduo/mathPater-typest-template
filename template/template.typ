#import "utils.typ":*
#import "@preview/numbly:0.1.0": numbly

/*定义字号*/
#let 字号 = (
  初号: 42pt,
  小初: 36pt,
  一号: 26pt,
  小一: 24pt,
  二号: 22pt,
  小二: 18pt,
  三号: 16pt,
  小三: 15pt,
  四号: 14pt,
  中四: 13pt,
  小四: 12pt,
  五号: 10.5pt,
  小五: 9pt,
  六号: 7.5pt,
  小六: 6.5pt,
  七号: 5.5pt,
  小七: 5pt,
)

/*定义字体*/
#let 字体 = (
  仿宋: ("Times New Roman", "FangSong"),
  宋体: ("Times New Roman", "SimSun"),
  黑体: ("Times New Roman", "SimHei"),
  楷体: ("Times New Roman", "KaiTi"),
  代码: ("Consolas", "Times New Roman", "SimSun"),
)

/*定义图样式*/
#let img(img, caption: "")={
  figure(
    img, //图片
    caption: caption, //图名
    supplement: [图], //标签
    numbering: "1", //编号
    kind: "image", //类型
  )
}

/*定义表格样式*/
#let tbl(tbl, caption: "")={
  figure(
    tbl, //表格
    caption: caption, //标题
    supplement: [表], //标签
    numbering: "1", //编号样式
    kind: "table", //类型
  )
}


/*定义代码块*/
#let code(code, caption: "", desc: "")={
  if desc == "" {
    desc = caption;
  }
  figure(
    table(columns: 80%, align: left + horizon, 
    stroke: none, 
    table.hline(stroke: 1.5pt), 
    table.header([
      #set text(fill: green)
      \// *#desc*
    ]), table.hline(stroke: 1pt), block(code), table.hline(stroke: 1.5pt)),
    caption: caption, //标题
    supplement: [代码], //标签
    numbering: "1.", //编号样式
    kind: "code", //类型
  )
}

/*定义附录代码样式*/
#let codeAppendix(code,caption:"")={
  figure(
    code,
    caption: caption,
    supplement: [附录],
    numbering: "1:",
    kind: "codeAppendix"
  )
}


/*定义公式样式*/
#let equation(equation)={
  figure(
    equation, //公式
    supplement: [式], //标签
    //numbering: equation_num,//编号样式
    numbering: "(1)", //编号样式
    kind: "equation", //类型
  )
}

/*符号说明*/
#let symbolDesc(syms: ([$A$], [$B$], [$C$]), desc: ([测试1], [测试2], [测试3]))={
  if syms.len() != desc.len() {
    return
  }
  align(center)[
    #table(
      columns: (10%, 85%),
      align: (center + horizon, left + horizon),
      stroke: none,
      table.hline(stroke: 1.5pt),
      table.header([*符号*], align(center)[*说明*]),
      table.hline(stroke: 1pt),
      ..syms.zip(desc).flatten(),
      table.hline(stroke: 1.5pt),
    )
  ]
}

/*目录页*/
#let contents()={
  align(center)[
    #set text(font: 字体.黑体, size: 字号.四号)
    #pagebreak()//换页
    目#h(1.5em)录
  ]
  parbreak()//换行
  show outline:it=>{
    set text(font: 字体.黑体,size: 字号.小四)
    it
    parbreak()
  }
  outline(
    title: none,
    indent: true,
  )
  //pagebreak()//换页
}

//定义手动缩进
#let indent = h(2em)

#let template(body, abstract: [摘要内容], title: "测试题目", keywords: ([key1], [key2], [key3])) = {
  //设置页面
  set page(
    paper: "a4", 
    margin: (x: 2.5cm, y: 2.5cm),
    numbering: numbly("{1}","第{1}页  共{2}页"),
  )
   
  //设置文本样式
  set text(
    font: 字体.宋体,
    size: 字号.小四, //正文字体大小
    fill: black,
    lang: "zh",
  )
   
  //创建假段落样式，解决自动缩进
  let fake-par = style(styles=>{
    let b = par[#box()]
    let t = measure(b + b, styles)
    b
    v(-t.height)
  })
  show strong: it => text(font: 字体.黑体, weight: "semibold", it.body)//设置加粗字体
  show emph: it => text(font: 字体.楷体, style: "italic", it.body)//设置倾斜字体
   
  //设置标题样式
  set heading(numbering: numbly(
    "{1:一、}",
    "{1:1}.{2}",
    "{1:1}.{2:1}.{3:1}"
  ))
   
  show heading.where(level: 1):it=>{ //单独设置一级标题
    set align(center)
    set text(font: 字体.黑体, size: 字号.四号)
    it
  }
  show heading.where(level: 2):it=>{ //单独设置二级标题
    set align(left)
    set text(font: 字体.黑体, size: 字号.小四)
    it
    v(0.15em)//二级标题后 行距
  }
  show heading.where(level: 3):it=>{ //单独设置三级标题
    set align(left)
    set text(font: 字体.黑体, size: 字号.小四)
    it
  }
   
  show heading:it =>{
    it
    fake-par
  }
   //设置有序列表格式
   set enum( numbering:  " (1)")
   
  //设置段落
  set par(
    justify: true, //两端对齐
    first-line-indent: 2em, //首段缩进
    leading: 0.8em, //行距
  )
   
  //设置图、表、代码样式
  show figure: it =>[
    #set align(center);//设置居中
    #set block(breakable: true)//允许表格换行
    #if it.kind == "image" { //图
      it.body
      //设置标题样式
      set text(font: 字体.黑体, size: 字号.五号)
      it.caption
    } else if it.kind == "table" { //表
      //表标题
      set text(font: 字体.黑体, size: 字号.五号)
      it.caption
      //设置表字体
      set text(font: 字体.宋体, size: 字号.五号)
      it.body
    } else if it.kind == "code" { //代码
      //设置标题样式
      set text(font: 字体.黑体, size: 字号.小五)
      it.caption
      //设置代码字体
      set text(font: 字体.代码, size: 字号.五号)
      it.body
    } else if it.kind == "equation" { //公式
      //通过大比例来达到中间靠右的排布
      grid(
        columns: (20fr, 1fr), //两列
        it.body, //显示公式
        align(center + horizon, it.counter.display(it.numbering)), //显示编号
      )
    } else if it.kind=="codeAppendix"{//附录代码
    table(
      columns: 100%,
      fill: (x,y)=>{if(x==0 and y==0){gray}},
      table.header(align(left)[*#it.caption*], repeat: false),
      [
        #set par(leading: 0.45em)
        #align(left)[
          #set text(font: 字体.代码, size: 字号.五号)
          #it.body]
      ]
    )}else {
      it
    }
  ]

  [
    #set page(footer: [#none])
    #[//题目
      #set text(font: 字体.黑体, size: 字号.三号)
      #align(center)[#title]
    ]
    #[
      //摘要字
      #set text(font: 字体.黑体, size: 字号.四号)
      #align(center)[摘#h(0.5em)要]
    ]
     
    #abstract
    #v(2em)
    //关键字
    #[
      #set text(font: 字体.黑体, size: 字号.小四)
      关键词
    ]
     
    #for item in keywords{
      item 
      h(1.5em)
    }
    /*目录*/
    #contents()
  ]


  
  counter(page).update(1)
  body //正文

}

