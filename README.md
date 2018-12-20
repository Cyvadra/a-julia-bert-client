# a-julia-bert-client

1. download model, then run [bert-as-service](https://github.com/hanxiao/bert-as-service)

    > pip install bert-serving-server

    > bert-serving-start -model_dir ./model_dir -num_worker=4
    
2. in julia

    > include("BertClient.jl")
    
    > BertClient.bert_encode(str)
    
    bert_encode( array ) is also okay
    
    bert_init() is optional, 
    
    default:  tcp_server_address="127.0.0.1", port_client_input=5555, port_server_output=5556

---

not quite familiar with writing julia packages, so just a script... mainly no idea how to.. pack?

you can also copy code from this .jl to simplify operations

