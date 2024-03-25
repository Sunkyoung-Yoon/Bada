package com.bada.badaback.file.service;

import com.bada.badaback.common.ServiceTest;
import com.bada.badaback.file.config.S3MockConfig;
import com.bada.badaback.file.exception.FileErrorCode;
import com.bada.badaback.global.exception.BaseException;
import io.findify.s3mock.S3Mock;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Import;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.web.multipart.MultipartFile;

import java.io.FileInputStream;
import java.io.IOException;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@Import(S3MockConfig.class)
@DisplayName("File [Service Layer] -> FileService 테스트")
class FileServiceTest extends ServiceTest {
    @Autowired
    private FileService fileService;

    @Autowired
    private S3Mock s3Mock;

    private final String FILE_PATH = "src/test/resources/files/";

    @AfterEach
    public void tearDown() {
        s3Mock.stop();
    }

    @Nested
    @DisplayName("Member 프로필 이미지 업로드")
    class uploadBoardFiles {
        @Test
        @DisplayName("빈 파일이면 업로드에 실패한다")
        void throwExceptionByEmptyFile() {
            // given
            MultipartFile nullFile = null;
            MultipartFile emptyFile = new MockMultipartFile("member", "empty.png", "image/png", new byte[]{});

            // when - then
            assertThatThrownBy(() -> fileService.uploadMemberFiles(nullFile))
                    .isInstanceOf(BaseException.class)
                    .hasMessage(FileErrorCode.EMPTY_FILE.getMessage());
            assertThatThrownBy(() -> fileService.uploadMemberFiles(emptyFile))
                    .isInstanceOf(BaseException.class)
                    .hasMessage(FileErrorCode.EMPTY_FILE.getMessage());
        }

        @Test
        @DisplayName("파일 업로드에 성공한다")
        void success() throws Exception {
            // given
            String fileName = "test.png";
            String contentType = "image/png";
            String dir = "member";
            MultipartFile file = createMockMultipartFile(dir, fileName, contentType);

            // when
            String fileKey = fileService.uploadMemberFiles(file);

            // then
            assertThat(fileKey).contains("test.png");
            assertThat(fileKey).contains(dir);
        }
    }

    private MultipartFile createMockMultipartFile(String dir, String fileName, String contentType) throws IOException {
        try (FileInputStream stream = new FileInputStream(FILE_PATH + fileName)) {
            return new MockMultipartFile(dir, fileName, contentType, stream);
        }
    }
}
