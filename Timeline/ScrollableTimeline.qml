import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

Item {
    id: scrollableTimeline

    property MediaPlayer externalVideoPlayer
    property bool hasCurrentIndexChanged: false
    Layout.fillWidth: true
    Layout.fillHeight: true

    Rectangle {
        id: timelineBackground
        width: parent.width
        height: 50
        color: "transparent"
        radius: 5

        VideoClip{
            id: videoClipInstance
            clipDuration: externalVideoPlayer.duration
            timelineVideoPlayer:externalVideoPlayer

        }
    }


    Connections {
        target: externalVideoPlayer

        function onPositionChanged() {
            syncCursorWithTimeline()

        }

    }

    function syncCursorWithTimeline(){
        if (!videoClipInstance || externalVideoPlayer.duration <= 0) {
            return;
        }

        let progressRatio = externalVideoPlayer.position / externalVideoPlayer.duration;
        let totalThumbnails = videoClipInstance.totalThumbnails;
        let newIndex = Math.floor(progressRatio * totalThumbnails);
        let newPage = Math.floor(newIndex / videoClipInstance.thumbnailsPerPage);
        let stableThumbnailsPerPage = 15;
        let pageStartTime = newPage * stableThumbnailsPerPage * (externalVideoPlayer.duration / totalThumbnails);
        let listViewX =  timelineBackground.x + 10
        let newCursorX = ((externalVideoPlayer.position - pageStartTime) / (stableThumbnailsPerPage * 1000)) * videoClipInstance.width;

        if(newPage!==0 && hasCurrentIndexChanged){
            stableThumbnailsPerPage = 7;
            listViewX=timelineBackground.width/2+40;
            pageStartTime = newPage * stableThumbnailsPerPage * (externalVideoPlayer.duration / totalThumbnails);
            newCursorX = ((externalVideoPlayer.position - pageStartTime) / (stableThumbnailsPerPage * 1000)) * videoClipInstance.width/2 - 100;

        }

        if (newPage !== videoClipInstance.currentPage) {
            hasCurrentIndexChanged=true
            videoClipInstance.currentPage = newPage;
            videoClipInstance.thumbnailsPerPage = 7;
            videoClipInstance.thumbnailListView.currentIndex = newPage * videoClipInstance.thumbnailsPerPage;
            videoClipInstance.playerHead.x =videoClipInstance.centeredPlayer.x +50 ;

        } else {
            videoClipInstance.playerHead.x = listViewX + newCursorX;
        }
    }
}
