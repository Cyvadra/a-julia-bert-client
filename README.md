# a-julia-bert-client

1. download [model](https://github.com/google-research/bert), then run [bert-as-service](https://github.com/hanxiao/bert-as-service)
    ``` shell

     pip install bert-serving-server

     bert-serving-start -model_dir ./model_dir -num_worker=4
    ``` 
    
2. in julia

    ``` julia
     include("BertClient.jl")
    
     BertClient.bert_encode(str)
    ```
    
    bert_encode( [str1,str2,...] ) is also okay
    
    bert_init() is optional, 
    
    default:  tcp_server_address="127.0.0.1", port_client_input=5555, port_server_output=5556

---

remember to install tensorflow-gpu for (server side) better performance

no need to pack into a package I guess?

