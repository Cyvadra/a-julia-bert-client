# a-julia-bert-client

1. download [model](https://github.com/google-research/bert), then run [bert-as-service](https://github.com/hanxiao/bert-as-service)
    ``` shell

     pip install bert-serving-server

     bert-serving-start -model_dir ./model_dir -num_worker=4
    ``` 
    
2. in julia

    ``` julia
    julia> include("BertClient.jl")
    julia> bert_encode("我能吞下玻璃而不伤身体")
                768-element Array{Float32,1}:
                  0.63951504 
                  0.11443944 
                 -0.09068978 
                  0.011962767
                  0.19503269 
                 -0.5136112  
                 -0.28722548 
                 -0.24000126 
                 -0.09366071 
                  0.9944896  
                  0.11499034 
                ⋮ 
    ```
    
    bert_encode( [str1,str2,...] ) is also okay
    
    bert_init() is optional, 
    
    default:  tcp_server_address="127.0.0.1", port_client_input=5555, port_server_output=5556

---

remember to install tensorflow-gpu for (server side) better performance


### notice

    bert-as-service may not be stable when not optimized


