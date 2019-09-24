package main

import (
	"encoding/base64"
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"strings"
)

type serverFlags []string

func (f *serverFlags) String() string {
	return strings.Join(*f, ",")
}

func (f *serverFlags) Set(value string) error {
	*f = append(*f, value)
	return nil
}

var (
	port          string
	image         string
	client        bool
	servers       serverFlags
)

func init() {
	flag.StringVar(&port, "port", "80", "give me a port number")
	flag.BoolVar(&client, "client", false, "I'm a client?")
	flag.StringVar(&image, "image", "maroilles.png", "give me image name")
	flag.Var(&servers, "servers", "give me url server")
}

func main() {
	flag.Parse()

	fmt.Println(client)
	if client {
		fmt.Println("Client with servers", strings.Join(servers, ", "))
		http.HandleFunc("/", clientHandler)
	} else {
		fmt.Println("Server with image ", image)
		http.HandleFunc("/", serverHandler)
	}

	fmt.Println("Starting up on port " + port)

	log.Fatal(http.ListenAndServe(":"+port, nil))
}

func serverHandler(w http.ResponseWriter, req *http.Request) {
	file, err := ioutil.ReadFile("./static/" + image)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	if _, err := fmt.Fprintf(w, base64.RawStdEncoding.EncodeToString(file)); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
}

func clientHandler(w http.ResponseWriter, req *http.Request) {
	var datas []string
	for _, server := range servers {
		resp, err := http.Get(server)
		if err != nil {
			datas = append(datas, "NotFound")
			fmt.Println(err)
			continue
		}

		defer resp.Body.Close()
		body, _ := ioutil.ReadAll(resp.Body)
		datas = append(datas, string(body))
	}
	data := `
	<!DOCTYPE html>
	<html>
		<head>
			<meta name="viewport" content="width=device-width, initial-scale=1">
			<style>
				* {
				box-sizing: border-box;
				}

				/* Create two equal columns that floats next to each other */
				.column {
				float: left;
				width: 50%;
				padding: 10px;
				height: 300px; /* Should be removed. Only for demonstration */
				}

				/* Clear floats after the columns */
				.row:after {
				content: "";
				display: table;
				clear: both;
				}
			</style>
		</head>
		<body>`
	for i, value := range datas {
		if i%2 == 0 {
			data = data + `<div class="row">`
		}

		data = data + `<div class="column"><img width="256px" alt="" src="data:image/png;base64,`+ value  +`" /></div>`
		if i%2 != 0 {
			data = data + `</div>`
		}
	}


	data = data + `</body></html>`
	if _, err := fmt.Fprintf(w, data); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
}
