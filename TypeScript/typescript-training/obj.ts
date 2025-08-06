interface Person{
    name:string;
    age:number;
    sayName():void;
}

let c:Person={
    name:"小明",
    age:18,
    sayName(){
        console.log(this.name);
    }
};

c.sayName();