const slider = document.querySelector('.slider');
const sections = Array.from(slider.children).length;
slider.style.width = (sections)+'00%';
const leftArrow = document.querySelector('.left');
const rightArrow = document.querySelector('.right');

var current = 0;
var target = 0;

var dotList = document.getElementById("dotList");
for(var i=0; i < sections; i++){
    var dot = document.createElement("li");
    if (i === 0){
        dot.className = "selected";
    }
    dotList.appendChild(dot);
}
const dots = Array.from(dotList.children);

function startSlide(){
    dots[current].classList.remove('selected');
    slider.style.transform = 'translate(-' + (target * 100/sections) + '%)';
    dots[target].classList.add('selected');

    current = target;
}

rightArrow.addEventListener('click', function(){
    target = (current + 1)%sections;
    startSlide();
});

leftArrow.addEventListener('click', function(){
    target = (current + sections - 1)%sections;
    startSlide();
});

document.querySelectorAll('.controls li').forEach(function(dot, id){
    dot.addEventListener('click', function(){
        target = id;
        startSlide();
    });
});

