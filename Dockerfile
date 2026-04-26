#Containrizing the go web app

#Start with a base image
FROM golang:1.25 as base

#set the working directory inside the container
WORKDIR /app

#Copy the go.mod gile in the working directory
COPY go.mod ./

#Download all the dependencies
RUN go mod download

#copy the source code in the directory
COPY . .

#build the application
RUN go build -o main .

#############################
#Reduce the image size using multi-stage build

# We will use a distroless image to run the application
FROM gcr.io/distroless/base

#Copy the binary from the previous stage
COPY --from=base /app/main .

#Copy static files from the previous stage
COPY --from=base /app/static ./static

#Expose the port where the application will run
EXPOSE 8080

#Command to run the application
CMD ["./main"]