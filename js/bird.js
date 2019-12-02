
class Bird {
    constructor(id){
        this.me = document.getElementById(id);
        this.x = 10;
        this.y = 10;
        this.duration = 0;
    }

    clamp(n, min, max){
        if (n < min) return min;
        if (n > max) return max;
        return n;
    }

    run(){
        this.duration = 1000 + Math.floor(Math.random()*5000);
        const dx = (Math.random()-this.x/100)*80;
        const dy = (Math.random()-this.y/100)*80;
        if (dx < 0){
            this.me.style.transform = "scaleX(-1)";
        }else{
            this.me.style.transform = "scaleX(1)";
        }

        this.x += dx;
        this.y += dy;

        this.x = this.clamp(this.x, 5, 95);
        this.y = this.clamp(this.y, 5, 95);

        this.me.style.left = this.x + '%';
        this.me.style.top = this.y + '%';
        this.me.style.transitionDuration = this.duration + 'ms';

        window.setTimeout( ()=>{
            this.run();
        }, this.duration);
    }
}

const theSky = document.querySelector('.sky');
const birdDiv = document.createDocumentFragment();
const birdsAmount = 3;

for (let i = 0; i < birdsAmount; i ++){
    const div = document.createElement('div');
    div.classList.add('bird');
    div.id = 'bird'+i;
    div.innerHTML = "<svg viewBox='0 0 210 297' xmlns:xlink='http://www.w3.org/1999/xlink'><use xlink:href='#birdSvg'/> </svg>";
    birdDiv.appendChild(div);
}

theSky.appendChild(birdDiv);

for (let i = 0; i < birdsAmount; i ++){
    const birdy = new Bird('bird'+i);
    console.log(document.getElementsByTagName('path').length);
    
    //birdy.me.getElementsByTagName('path')[0].style.fill = '#ccc';
    birdy.run();
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