
class Firefly {
    constructor(id){
        this.me = document.getElementById(id);
        this.x = 10;
        this.y = 10;
        this.duration = 0;
        this.size = 0.7 + Math.random()*0.8;
        this.me.style.width = (this.size * 40)+'px';
        this.me.style.height = this.me.style.width;
    }

    clamp(n, min, max){
        if (n < min) return min;
        if (n > max) return max;
        return n;
    }

    move(){
        this.duration = 1000 + Math.floor(Math.random()*5000);
        const dx = (Math.random()-this.x/100)*60;
        const dy = (Math.random()-this.y/100)*60;
        this.x += dx;
        this.y += dy;

        this.x = this.clamp(this.x, 5, 95);
        this.y = this.clamp(this.y, 5, 95);

        this.me.style.left = this.x + '%';
        this.me.style.top = this.y + '%';
        this.me.style.transitionDuration = this.duration + 'ms';

        window.setTimeout( ()=>{
            this.move();
        }, this.duration);  
    }

    run(){
        this.move();
    }
}

const theSky = document.querySelector('.sky');
const flyDiv = document.createDocumentFragment();
const flyAmount = 3;

for (let i = 0; i < flyAmount; i ++){
    const div = document.createElement('div');
    div.classList.add('firefly');
    div.id = 'firefly'+i;
    flyDiv.appendChild(div);
}

theSky.appendChild(flyDiv);

for (let i = 0; i < flyAmount; i ++){
    const fly = new Firefly('firefly'+i);
    fly.run();
}

// const flyingAnimation = anime.timeline({
//     targets: '.sky div',
//     easing: 'easeInOutSine',
//     loop: true,
//     autoplay: true,
// })
// .add({
//     left: ()=> anime.random(10, 50)+'%',
//     top: ()=> anime.random(10, 50)+'%',
//     duration: function(el, i, l){
//         return anime.random(1000, 3000);
//     },
// })
// .add({
//     left: ()=> anime.random(30, 70)+'%',
//     top: ()=> anime.random(30, 70)+'%',
//     duration: function(el, i, l){
//         return anime.random(1000, 3000);
//     },
// })
// .add({
//     left: ()=> anime.random(50, 90)+'%',
//     top: ()=> anime.random(50, 90)+'%',
//     duration: function(el, i, l){
//         return anime.random(1000, 3000);
//     },
// })
// .add({
//     left: ()=> anime.random(30, 70)+'%',
//     top: ()=> anime.random(30, 70)+'%',
//     duration: function(el, i, l){
//         return anime.random(1000, 3000);
//     },
// })
// .add({
//     left: ()=> anime.random(10, 90)+'%',
//     top: ()=> anime.random(10, 90)+'%',
//     duration: function(el, i, l){
//         return anime.random(1000, 3000);
//     },
// })
// .add({
//     left: ()=> anime.random(10, 50)+'%',
//     top: ()=> anime.random(10, 50)+'%',
//     duration: function(el, i, l){
//         return anime.random(1000, 3000);
//     },
// })
// .add({
//     left: '10%',
//     top: '10%',
//     duration: function(el, i, l){
//         return anime.random(1000, 4000);
//     },
// });

// flyingAnimation.play();