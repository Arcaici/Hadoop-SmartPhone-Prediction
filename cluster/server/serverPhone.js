const express = require("express");
const app = express();

const fs = require("fs");

//web page 
app.get("/index",(req,res)=>{
    let index = fs.readFileSync("page.html","utf-8");
    res.send(index);
});

//resource with plot data
app.get("/loadRawData",(req,res)=>{

    let class_predicted = req.query.class_predicted;
    let plot_data = [];

    plot_data.push(pie[class_predicted]);
    plot_data.push(bar_v[class_predicted]);
    plot_data.push(bar_h[class_predicted]);

    res.send(plot_data);
});

//server listening to 8081 because openscoring listen to 8080
app.listen("8081",()=>{
    console.log("PhonePrediction Online port:8081");

    //loading data from hive querys results folders (already exported in local)
    let path_fc = 'price_fc_';
    let path_ram = 'price_ram_';
    let path_battery = 'price_battery_power_';
    let file_name = '000000_0'

    //pie data inizialization
    let fc_range = ['10', '10_15', 'm_15'];
     
    pie =[{
                id: 0,
                val: [],
                range:[]
            },{
                id : 1,
                val: [],
                range:[]
            },{
                id : 2,
                val: [],
                range:[]
            },{
                id : 3,
                val: [],
                range:[]
            }
    ];

    for(let el of fc_range){
        let query = fs.readFileSync(path_fc + el + "/" + file_name, "utf-8");

        for(let line of query.split("\n")){
            if(line[1] == null){break};
            temp_split = line.split(",");
            pie[temp_split[1]].val.push(temp_split[0])
            pie[temp_split[1]].range.push(el)
        }
    }
    
    //barplot vertical
    ram_range = ["500", "500_1000", "1000_2000", "2000_3000", "m_3000"];

    bar_v = [{
                id: 0,
                val: [],
                range:[]
            },{
                id : 1,
                val: [],
                range:[]
            },{
                id : 2,
                val: [],
                range:[]
            },{
                id : 3,
                val: [],
                range:[]
            }
    ];

    for(let el of ram_range){
        let temp_split;
        let query = fs.readFileSync(path_ram + el + "/" + file_name, "utf-8");
        for(let line of query.split("\n")){
            if(line.split(",")[1] == null){break};
            temp_split = line.split(",");
            bar_v[temp_split[1]].val.push(temp_split[0])
            bar_v[temp_split[1]].range.push(el);
        }
    }

    //barplot horizzontal
    let battery_range = ["500_800", "800_1000", "1000_1200", "1200_1400", "m_1400"];
    bar_h = [{
                    id: 0,
                    val: [],
                    range: []
                },{
                    id : 1,
                    val: [],
                    range: []
                },{
                    id : 2,
                    val: [],
                    range: []
                },{
                    id : 3,
                    val: [],
                    range: []
                }
    ];

    for(let el of battery_range){
        let temp_split;
        let query = fs.readFileSync(path_battery + el + "/" + file_name, "utf-8");
        
        for(let line of query.split("\n")){
            if(line.split(",")[1] == null){break};
            temp_split = line.split(",");
            bar_h[temp_split[1]].val.push(temp_split[0])
            bar_h[temp_split[1]].range.push(el);
        }
    }  
});