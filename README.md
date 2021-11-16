# Among Us TODOs API

![Among Us banner](docs/img/banner.jpg)

Fake REST API server of tasks from Among Us

## Getting Started

This application is backed by the default data from a json file (default to be `db.json`, however it can be specified through an environment variable).
The underlying server that power the application is [json-server](https://github.com/typicode/json-server)

### Instructions for AWS

Upon push, the CI/CD pipeline automatically builds and publishes the docker image into dockerhub: [https://hub.docker.com/r/alkaffahamed/amongus-capstone](https://hub.docker.com/r/alkaffahamed/amongus-capstone)

Requirements: 

1. Terraform 1.0.5 

2. AWS CLI with login credentials configured 

3. AWS EC2 key with the name "`amongus`" inside `terraform/amongus.pem`
   can be created by this command
   
   ```shell
   aws ec2 create-key-pair --key-name amongus --query 'KeyMaterial' --output text > amongus.pem
   chmod 400 amongus.pem
   ```
   
4. Setup Terraform State in backend S3 
   - init terraform locally, then migrate to S3

Steps: 

1. Run the following commands: 

   ```shell
   terraform init
   terraform plan
   terraform apply
   ```

   This will spin up an EC2 Instance. On the console, the Public and Private IP address will be printed. Take note of the Public IP Address `[public_ip]` as it will be useful later.

2. SSH into the Public IP Address: 

   ```shell
   ssh -i "amongus.pem" ec2-user@[public_ip]
   ```

3. Run the super-long command below: 

   ```shell
   sudo yum update -y; sudo yum install git -y; sudo yum install docker -y; sudo service docker start; sudo usermod -a -G docker ec2-user; sudo docker pull alkaffahamed/amongus-capstone:test; sudo docker run --name amongus_server -d -p 3000:3000 alkaffahamed/amongus-capstone:test; sudo docker port amongus_server
   ```

4. Open any browser and go to the address: 
   `http://[public_ip]:3000/`

5. The homepage will load. You can test the software using any API Testing tools (eg. Postman) 

6. After completing, **remember to shutdown** everything by running: 

   ``` shell
   exit # Exits the SSH
   terraform destroy # Tear down the Terraform Infrastructure
   ```

### Default Original Instructions

#### Starting the application

Simply `npm start` and the server will be started with the default configurations on port 3000 and db file to be `db.json`

#### App-level configurations

- `DB`: path to the json file that will be used as the database
- `PORT`: port that the app will start on

#### Testing

- Code linting: `npm run lint`
- Full test suite: `npm test`

## API Reference

Data from the json database file will be loaded every time the app starts and db writes will be made to the same file as well. Hence, a note on if the data is not commited into source, we might see differences between environments.

Listed below are basic usages of the API, more advanced usages can be found [here](https://github.com/typicode/json-server#routes).

### POST /todos

Create a new tasks

```
POST /todos

{
    text: string,
    type: "short" | "long" | "common"
}
```

### GET /todos/:id

Get task by ID

```
GET /todos/:id
```

### GET /todos

Get tasks

```
GET /todos
```

Possible query parameters:

- `q`: full text search
- `_page` and `_limit`: paginate
- any fields from the TODO object: filter using specific fields
- `_start` and `_end`: slice based on TODO ID

### PUT /todos/:id

Replace whole TODO item content

```
PUT /todos/:id

{
    text: string,
    type: "common" | "long" | "short"
}
```

### PATCH /todos/:id

Partial update TODO item

```
PATCH /todos/:id

{
    text?: string,
    type?: "common" | "long" | "short"
}
```

### DELETE /todos/:id

Delete a TODO item

```
DELETE /todos/:id
```

## Contributing

For any requests, bug or comments, please [open an issue](https://github.com/stanleynguyen/amongus-todo/issues) or [submit a pull request](https://github.com/stanleynguyen/amongus-todo/pulls).
