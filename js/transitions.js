//==================================
//All transitions
//==================================

const worksContainer = document.querySelector('.carousel-container');
const aboutContainer = document.querySelector('.container');

//Slide the carousel container
function slideDown(){
    worksContainer.style.top = '50%';
    worksContainer.style.opacity = '100%';
    toggle('.contentBox', 'blured');
    //fadeOut();
}

function slideUp(){
    worksContainer.style.top = '-50%';
    worksContainer.style.opacity = '0%';
    toggle('.contentBox', 'blured');
    //fadeIn();
}

function toggle(target, addOn){
    const container = document.querySelector(target);
    if (container.classList.contains(addOn)){
        container.classList.remove(addOn);
    }else{
        container.classList.add(addOn);
    }
}

//Toggle the about me layer
function showContent(_class){
    toggle(_class, 'unfolded');
}

//
function pullInfo(){
    toggle('.container', 'rotated');
    toggle('.sideInfo', 'slided');
    toggle('.sideMask', 'maskOn');
}