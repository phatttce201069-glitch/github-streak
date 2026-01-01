# GitHub Activity Streak

Dự án tự động duy trì chuỗi commit hàng ngày và hỗ trợ farm commit không tốn dung lượng lưu trữ trên GitHub.

## Đặc điểm
- **Không tốn dung lượng (0 byte file diff)**: Sử dụng cờ `git commit --allow-empty`.
- **Tự động 100%**: GitHub Actions chạy định kỳ mỗi ngày trên cloud, không cần bật máy tính.
- **Linh hoạt**: Có script PowerShell để farm bù ngày cũ hoặc farm thêm tức thì.
