module BertClient

    using JSON, ZMQ, PyCall

    export tcp_server_address, port_client_input, port_server_output, bert_encode, bert_init

    numpy                   = pyimport("numpy")
    self_identity           = "1a2c7aaa-9636-0150-8aaa-f8eb2fd68043" # id doesn't really matter
    s2u(s::AbstractString)  = join(["\\u"*string(Int(c), base=16, pad=4) for c in s]) # thanks Bogumit Kaminski for this func
    self_context    = ZMQ.Context()
    self_sender     = Socket(ZMQ.PUSH)
    self_receiver   = Socket(ZMQ.SUB)

    function bert_init(tcp_server_address="127.0.0.1", port_client_input=5555, port_server_output=5556)
        connect(self_sender,"tcp://$tcp_server_address:$port_client_input")
        subscribe(self_receiver,self_identity)
        connect(self_receiver,"tcp://$tcp_server_address:$port_server_output")
    end

    bert_init()

    function bert_encode( texts::Array, req_id = abs(rand(Int8)) )
    	texts_send = "[\"" * join( map(x->s2u(x),texts),"\",\"" ) * "\"]"
    	msg = ZMQ.Message("$(self_identity)")
        	ZMQ.send(self_sender, msg; more=true)
    	msg = ZMQ.Message(texts_send)
        	ZMQ.send(self_sender, msg; more=true)
    	msg = repr(req_id)
        	ZMQ.send( self_sender, Vector{UInt8}(msg)[1]; more=true )
    	msg = repr(length(texts))
        	ZMQ.send( self_sender, Vector{UInt8}(msg)[1]; more=false )

        client_id   = ZMQ.recv(self_receiver)
        header_json = join( map(x->Char(x), ZMQ.recv(self_receiver)) )
        res_content = ZMQ.recv(self_receiver)
        req_id 		= ZMQ.recv(self_receiver)

        header_json = JSON.Parser.parse(header_json)
        res_content = convert(Array,res_content)
        res_content = py"memoryview($res_content)"
        res_content = numpy["frombuffer"](res_content,dtype="float32")
        res_content = reshape(res_content,(header_json["shape"][1],header_json["shape"][2]))

        res_array = Array{Float32,1}()
        for i in 1:length(texts)
        	append!(res_array,res_content[i,:])
        end
        res_array
    end


    function bert_encode( text::String, req_id = abs(rand(Int8)) )
    	return bert_encode([text],req_id)
    end


end