const slider = document.querySelector('.slider');
const sliders = Array.from(slider.children);
const sections = sliders.length;
slider.style.width = (sections)+'00%';

var current = 0;
var target = 0;
var activeSlide = -1;
const colors = [    'rgba(53, 177, 37, 0.3)', 
                    'rgba(20, 6, 51, 0.3)', 
                    'rgba(14, 121, 153, 0.3)', 
                    'rgba(93, 193, 213, 0.3)', 
                    'rgba(13, 193, 93, 0.3)'];

var dotList = document.getElementById("dotList");
for(var i=0; i < sections; i++){
    var dot = document.createElement("div");
    if (i === 0){
        dot.className = "selected";
    }
    dotList.appendChild(dot);
}
const dots = Array.from(dotList.children);

function startSlide(){
    const lastVideo = slider.children[current].getElementsByTagName('video')[0];
    lastVideo.pause();
    const currentVideo = slider.children[target].getElementsByTagName('video')[0];
    currentVideo.play();
    currentVideo.muted = true;
    dots[current].classList.remove('selected');
    slider.style.transform = 'translate(-' + (target * 100/sections) + '%)';
    slider.style.backgroundColor = colors[target];
    dots[target].classList.add('selected');
    current = target;
}

function slideRight(){
    target = (current + 1)%sections;
    startSlide();
}

function slideLeft(){
    target = (current + sections - 1)%sections;
    startSlide();
}

document.querySelectorAll('#dotList div').forEach(function(dot, id){
    const caseName = slider.children[id].getElementsByTagName('h1')[0].textContent;
    if (caseName)
        dot.style.backgroundImage = "url('videos/" + caseName + " Ico.png')";
    dot.style.backgroundSize = "cover";
    dot.addEventListener('click', function(){
        target = id;
        startSlide();
    });
});

//==================================
//All transitions
//==================================

const worksContainer = document.querySelector('.carousel-container');
const aboutContainer = document.querySelector('.container');

//Slide the carousel container
function slideDown(){
    worksContainer.style.top = '50%';
    worksContainer.style.opacity = '100%';
    toggle('.container', 'blured');

    const currentVideo = slider.children[target].getElementsByTagName('video')[0];
    currentVideo.play();
    currentVideo.muted = true;
}

function slideUp(){
    worksContainer.style.top = '-50%';
    worksContainer.style.opacity = '0%';
    toggle('.container', 'blured');

    const lastVideo = slider.children[current].getElementsByTagName('video')[0];
    lastVideo.pause();
}

//
function pullInfo(){
    toggle('.container', 'rotated');
    toggle('.sideInfo', 'slided');
    toggle('.sideMask', 'maskOn');
}
