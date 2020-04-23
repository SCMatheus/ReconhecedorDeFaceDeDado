clc
obj = VideoReader('VideoDado4.mp4');
numFrames = obj.NumberOfFrames;
janela = 80;
 for k=1:(numFrames-2)

    IM = read(obj,k);
    FRAME2 = read(obj,k+2);
    IMGray = rgb2gray(IM(:,:,1:3));

    IMbw=im2bw(IMGray,0.5);

    IMneg=imadjust(IMGray,[0 1],[1 0]);

    %*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

    i1=IM(:,:,:);

    i2=FRAME2(:,:,:);

    i1=rgb2gray(i1(:,:,1:3));

    i2=rgb2gray(i2(:,:,1:3));

    m=abs(double(i1)-double(i2))/256;


    %     sum(sum(m))

    %     media=[media sum(sum(m))];

    if ~(sum(sum(m))>850)
            
            im = FRAME2;
            [x y z] = size(im);

            %im = imresize(im,[1280 1280]);

			[im2 bi bj] = regiaoInteresse(im,janela,janela);
            imfinal = rgb2gray(im2);
            imfinal = imfinal > 75;
            subplot(2,1,2);imshow(imfinal);title('Input Video-Image')
            [centersDark, radiiDark] = imfindcircles(imfinal,[4 13],'ObjectPolarity','dark');
            viscircles(centersDark, radiiDark,'Color','b');
    end
        subplot(2,1,1);imshow(FRAME2);title('Input Video-Image')
        mediaDaSoma = sum(sum(imfinal))/(janela*janela);
        if mediaDaSoma > 0.1
            
            line([bj,bj+janela],[bi,bi],'LineWidth',1,'Color','r')
            line([bj+janela,(bj+janela)],[bi+janela,bi],'LineWidth',1,'Color','r')
            line([bj,bj+janela],[bi+janela,bi+janela],'LineWidth',1,'Color','r')
            line([bj,bj],[bi,bi+janela],'LineWidth',1,'Color','r')
            [tamX tamY] = size(radiiDark);
            if tamX > 0 & tamX <= 6
                face = strcat('Numero: ', int2str(tamX));
            else
                face = 'Numero: indeterminado';
            end
            text(bj,bi+janela+10,face,'Color','red');
        end

end
